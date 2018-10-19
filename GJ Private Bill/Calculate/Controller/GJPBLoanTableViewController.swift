//
//  GJPBLoanTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

enum BILLLoanType {
    case interest
    case principal
}

class GJPBLoanTableViewController: UITableViewController {

    private var viewModel = GJPBLoanViewModel()
    
    var nav: UINavigationController?
    
    var loanType: BILLLoanType = .interest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = createFooterView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBLoanTableViewCell.self)
        tableView.registerCell(GJPBLoanTypeTableViewCell.self)
    }
    
    func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: UIDevice.screenWidth(), height: 200))
        
        let calculateButton = UIButton()
        calculateButton.backgroundColor = UIColor.mainColor()
        calculateButton.setTitle("计 算", for: .normal)
        calculateButton.setTitleColor(UIColor.white, for: .normal)
        calculateButton.clipRectCorner(.allCorners, cornerRadius: 2.5, roundedRect: CGRect(x: 0, y: 0, width: UIDevice.screenWidth() - 20, height: 45))
        calculateButton.addTarget(self, action: #selector(calculateButtonClick), for: .touchUpInside)
        footerView.addSubview(calculateButton)
        
        calculateButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
        }
        
        return footerView
    }
    
    @objc func calculateButtonClick() {
        view.endEditing(true)
        //判空
        if viewModel.money.isEmpty {
            view.makeToast("未输入贷款金额")
            return
        }
        
        if viewModel.yearNum.isEmpty {
            view.makeToast("未输入贷款年限")
            return
        }
        
        if viewModel.fee.isEmpty {
            view.makeToast("未输入贷款利率")
            return
        }
        
        //计算
        nav?.pushViewController(GJPBResultViewController(loanType: loanType, money: viewModel.money, time: viewModel.yearNum, fee: viewModel.fee), animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBLoanTypeTableViewCell
            
            cell.configure() { [weak self] (index) in
                if index == 101 {
                    self?.loanType = .interest
                }else {
                    self?.loanType = .principal
                }
            }
            
            return cell
        }
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBLoanTableViewCell
        
        cell.configure(dataSource: viewModel.cellMsg(indexPath: indexPath)) { [weak self] (text) in
            if indexPath.row == 0 {
                self?.viewModel.money = text ?? ""
            }else if indexPath.row == 1 {
                self?.viewModel.yearNum = text ?? ""
            }else {
                self?.viewModel.fee = text ?? ""
            }
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
