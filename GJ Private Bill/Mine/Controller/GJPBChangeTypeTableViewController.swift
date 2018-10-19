//
//  GJPBChangeTypeTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SCLAlertView

class GJPBChangeTypeTableViewController: UITableViewController {

    //支出按钮
    private lazy var spendingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 22))
        button.setTitle("支出", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.mainColor(), for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 80, height: 22)), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 80, height: 22)), for: .selected)
        button.isSelected = true
        button.addTarget(self, action: #selector(spendingButtonClick), for: .touchUpInside)
        button.clipRectCorner([.bottomLeft, .topLeft], cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 80, height: 22))
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    //收入按钮
    private lazy var incomeButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 80, y: 0, width: 80, height: 22))
        button.setTitle("收入", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.mainColor(), for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 80, height: 22)), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 80, height: 22)), for: .selected)
        button.addTarget(self, action: #selector(incomeButtonClick), for: .touchUpInside)
        button.clipRectCorner([.bottomRight, .topRight], cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 80, height: 22))
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupTableView()
    }
    
    private func setupNav() {
        
        let navTitleView = UIView(frame: CGRect(x: 0, y: 11, width: 160, height: 22))
        
        navTitleView.addSubview(spendingButton)
        
        navTitleView.addSubview(incomeButton)
        
        navigationItem.titleView = navTitleView
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBChangeTypeTableViewCell.self)
    }
    
    @objc func spendingButtonClick() {
        if spendingButton.isSelected {
            return
        }
        
        spendingButton.isSelected = true
        incomeButton.isSelected = false
        tableView.reloadData()
    }
    
    @objc func incomeButtonClick() {
        if incomeButton.isSelected {
            return
        }
        
        incomeButton.isSelected = true
        spendingButton.isSelected = false
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr.count: GJPBDataManager.share.incomeTypeArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBChangeTypeTableViewCell
        
        if spendingButton.isSelected {
            cell.configure(icon: GJPBDataManager.share.spendingTypeArr[indexPath.row].icon!, name: GJPBDataManager.share.spendingTypeArr[indexPath.row].name!)
        }else {
            cell.configure(icon: GJPBDataManager.share.incomeTypeArr[indexPath.row].icon!, name: GJPBDataManager.share.incomeTypeArr[indexPath.row].name!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //初始化UITextField
        var inputText: UITextField = UITextField()
        let msgAlertCtr = UIAlertController(title: "修改名称", message: "请输入新类别名称", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            if inputText.text == nil || inputText.text?.count == 0 {
                self.view.makeToast("新名称不能为空")
                return
            }
            
            GJPBDataManager.share.resetType(type: self.spendingButton.isSelected ? 0: 1, name: self.spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr[indexPath.row].name!: GJPBDataManager.share.incomeTypeArr[indexPath.row].name!, newName: inputText.text!, success: {
                let alertView = SCLAlertView(appearance: sclAppearance)
                alertView.addButton("好的") {
                    self.tableView.reloadData()
                }
                alertView.showWarning("提示", subTitle: "保存成功")
            }, fail: {
                let alertView = SCLAlertView(appearance: sclAppearance)
                alertView.addButton("好的") {
                    
                }
                alertView.showWarning("提示", subTitle: "保存失败")
            })
        }
        
        let cancel = UIAlertAction(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
        }
        
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
            inputText.placeholder = self.spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr[indexPath.row].name!: GJPBDataManager.share.incomeTypeArr[indexPath.row].name!
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }

}
