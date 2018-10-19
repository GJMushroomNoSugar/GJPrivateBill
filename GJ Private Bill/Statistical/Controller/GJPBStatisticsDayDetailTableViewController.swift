//
//  GJPBStatisticsDayDetailTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBStatisticsDayDetailTableViewController: UITableViewController {

    private var viewModel: GJPBStatisticsDayDetailViewModel
    
    private var type: Int16
    
    private var time: String
    
    private var name: String
    
    private lazy var noDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 55, width: UIDevice.screenWidth(), height: UIDevice.screenHeight() - 200))
        
        let imageView = UIImageView(image: UIImage(named: "GJPBNoData"))
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "当前没有数据"
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = UIColor(hex: "#999999")
        view.addSubview(tipLabel)
        
        tipLabel.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        })
        return view
    }()
    
    init(type: Int16, time: String, name: String) {
        self.type = type
        self.time = time
        self.name = name
        self.viewModel = GJPBStatisticsDayDetailViewModel(time: time)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = time
        
        setupTableView()
        
        reloadInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInfo), name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBMainTableViewCell.self)
        
    }
    
    @objc func reloadInfo() {
        self.noDataView.removeFromSuperview()
        //刷新数据
        GJPBDataManager.share.requestInfo(date: time, type: type, name: name) { [weak self] (arr) in
            self?.viewModel.billModelArr = arr
            if self?.viewModel.billModelArr.count == 0 {
                self?.tableView.addSubview(self!.noDataView)
                self?.tableView.bringSubviewToFront(self!.noDataView)
            }
            self?.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.billModelArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBMainTableViewCell
        
        cell.configure(dataSource: viewModel.cellMsg(indexPath: indexPath))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bill = viewModel.billModelArr[indexPath.row]
        
        navigationController?.pushViewController(GJPBRecordShowTableViewController(billModel: bill), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            GJPBDataManager.share.deleteBill(id: viewModel.billModelArr[indexPath.row].id!, success: {
                self.reloadInfo()
                self.view.makeToast("删除成功")
            }) {
                self.view.makeToast("删除失败")
            }
            
            
        }
        
    }
}
