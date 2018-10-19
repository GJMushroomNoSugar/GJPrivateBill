//
//  GJPBMineTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SCLAlertView

let kAppKey = "25112643"
let kAppSecret = "9344c4e17049a5aa9bc2196861f31dfb"
class GJPBMineTableViewController: UITableViewController {

    let feedbackKit = BCFeedbackKit.init(appKey: kAppKey, appSecret: kAppSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的"
        
        setupTableView()
        
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableHeaderView = createHeaderView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        
        tableView.registerCell(GJPBMineTableViewCell.self)
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 200))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GJPBTimg")
        headerView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(hex: 0x333333)
        label.text = "版本号: v" + "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")"
        headerView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        return headerView
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 4
        }
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBMineTableViewCell

        let nameArr = [["添加类别", "修改类别名称", "删除类别及排序", "反馈"], ["清除所有数据"]]
        cell.configure(color: indexPath.section == 1 ? UIColor.orange: UIColor(hex: 0x333333), name: nameArr[indexPath.section][indexPath.row])

        if indexPath.section != 1 {
            cell.accessoryType = .disclosureIndicator
        }else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let alertView = SCLAlertView(appearance: sclAppearance)
            alertView.addButton("取消") {
                
            }
            alertView.addButton("确定删除") {
                GJPBDataManager.share.clearData {
                    let alert = SCLAlertView(appearance: sclAppearance)
                    alert.addButton("好的") {
                        
                    }
                    alert.showWarning("提示", subTitle: "已清空所有数据")
                }
            }
            alertView.showWarning("警告", subTitle: "全部数据删除后将无法找回")

            return
        }else if indexPath.row == 0 {
            navigationController?.pushViewController(GJPBAddTypeViewController(), animated: true)
        }else if indexPath.row == 1 {
            navigationController?.pushViewController(GJPBChangeTypeTableViewController(), animated: true)
        }else if indexPath.row == 2 {
            navigationController?.pushViewController(GJPBDeleteTypeTableViewController(), animated: true)
        }else if indexPath.row == 3 {
            feedbackKit?.makeFeedbackViewController(completionBlock: { [weak self] (viewController, error) in
                if viewController == nil {
                    return
                }
                
                let nav = GJPBNavigationController(rootViewController: viewController!)
                self?.present(nav, animated: true, completion: nil)
                
                viewController?.closeBlock = { (aParentController) in
                    aParentController?.dismiss(animated: true, completion: nil)
                }
            })
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

}
