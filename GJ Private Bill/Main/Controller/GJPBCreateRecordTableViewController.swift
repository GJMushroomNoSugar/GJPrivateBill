//
//  GJPBCreateRecordTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SCLAlertView

let sclAppearance = SCLAlertView.SCLAppearance(
    showCloseButton: false
)
class GJPBCreateRecordTableViewController: UITableViewController {

    private var viewModel = GJPBCreateRecordViewModel()
    
    private var successCourse: ((_ model: Bill) -> ())?
    
    private var isChange = false
    
    init(model: Bill?, successCourse: ((_ model: Bill) -> ())?) {
        self.successCourse = successCourse
        if model != nil {
            self.viewModel.billModel = model!
            isChange = true
        }else {
            self.viewModel.recordModel = GJPBRecordModel(desc: nil, money: nil, time: nil, type: nil, typeName: nil, id: nil, icon: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var navTitle = "新建账单"
        if isChange {
            navTitle = "修改账单"
        }
        navigationItem.title = navTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItem.Style.done, target: self, action: #selector(save))
        
        setupTableView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "GJPBBackArrow"), style: .plain, target: self, action: #selector(navigationBack))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = createFooterView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBCreateMoneyTableViewCell.self)
        tableView.registerCell(GJPBCreateTypeTableViewCell.self)
        tableView.registerCell(GJPBCreateDescTableViewCell.self)
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 200))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GJPBEdit")
        footerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(75)
        }
        
        return footerView
    }
    
    @objc func navigationBack() {
        view.endEditing(true)
        if isChange {
            navigationController?.popViewController(animated: true)
            return
        }
        
        if viewModel.recordModel?.money == nil || viewModel.recordModel?.money?.count == 0 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let alertView = SCLAlertView(appearance: sclAppearance)
        alertView.addButton("不,留在页面") {
            
        }
        alertView.addButton("返回") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        alertView.showWarning("提醒", subTitle: "确定返回? 这笔账单将不会被保存")

    }
    
    @objc func save() {
        view.endEditing(true)

        if isChange {
            viewModel.change(success: { [weak self] in
                
                DispatchQueue.main.async {
                    guard let bill = self?.viewModel.billModel else {
                        self?.navigationController?.popViewController(animated: true)
                        return
                    }
                    
                    self?.successCourse?(bill)
                    self?.navigationController?.popViewController(animated: true)
                }
            }) {
                
            }
            return
        }
        
        viewModel.add(success: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }) {
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBCreateDescTableViewCell
            
            cell.configure(dataSource: viewModel) { [weak self] (text) in
                if self?.viewModel.billModel == nil {
                    self?.viewModel.recordModel?.desc = text
                }else {
                    self?.viewModel.billModel?.desc = text
                }
            }
            
            return cell
        }else if indexPath.row == 0 {
            
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBCreateMoneyTableViewCell
            cell.configure(dataSource: viewModel) { [weak self] (text) in
                if self?.viewModel.billModel == nil {
                    self?.viewModel.recordModel?.money = text
                }else {
                    self?.viewModel.billModel?.money = text
                }
            }
            
            return cell
        }
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBCreateTypeTableViewCell
        
        cell.configure(dataSource: viewModel.cellMsg(indexPath: indexPath))
        
        return cell
    }
    
    //MARK: -- Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            view.endEditing(true)
            let pickerView = GJPBPickerView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: UIDevice.screenHeight()), chooseType: .type(resultBack: { [weak self] (index, typeName) in
                if self?.viewModel.billModel == nil {
                    self?.viewModel.recordModel?.type = Int16(index)
                    self?.viewModel.recordModel?.typeName = typeName
                }else {
                    self?.viewModel.billModel?.type = Int16(index)
                    self?.viewModel.billModel?.typeName = typeName
                }
                
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }))
            pickerView.show()
        }else if indexPath.row == 2 {
            view.endEditing(true)

            let datePick = GJPBPickerView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: UIDevice.screenHeight()), chooseType: .date(resultBack: { [weak self] (date) in
                if self?.viewModel.billModel == nil {
                    self?.viewModel.recordModel?.time = Date.string(date: date, dateFormatter: "yyyy-MM-dd")
                }else {
                    self?.viewModel.billModel?.time = Date.string(date: date, dateFormatter: "yyyy-MM-dd")
                }
                
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }))
            datePick.show()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
