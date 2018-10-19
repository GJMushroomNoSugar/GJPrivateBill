//
//  GJPBDeleteTypeTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBDeleteTypeTableViewController: UITableViewController {

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
        tableView.bounces = false
        tableView.isEditing = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBDeleteTypeTableViewCell.self)
        
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
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBDeleteTypeTableViewCell
        
        let name = spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr[indexPath.row].name!: GJPBDataManager.share.incomeTypeArr[indexPath.row].name!
        let icon = spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr[indexPath.row].icon!: GJPBDataManager.share.incomeTypeArr[indexPath.row].icon!
        
        cell.configure(icon: icon, name: name)
        
        return cell
    }
    
    // 设置 cell 是否允许移动
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // 移动 cell 时触发
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        GJPBDataManager.share.exchangeType(type: spendingButton.isSelected ? 0: 1, row: sourceIndexPath.row, newRow: destinationIndexPath.row)
        if spendingButton.isSelected {
            GJPBDataManager.share.getSpendingTypeArr()
        }else {
            GJPBDataManager.share.getIncomeTypeArr()
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            GJPBDataManager.share.deleteType(type: spendingButton.isSelected ? 0: 1, name: spendingButton.isSelected ? GJPBDataManager.share.spendingTypeArr[indexPath.row].name!: GJPBDataManager.share.incomeTypeArr[indexPath.row].name!)
            if spendingButton.isSelected {
                GJPBDataManager.share.spendingTypeArr.remove(at: indexPath.row)
            }else {
                GJPBDataManager.share.incomeTypeArr.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
        }
    }

}
