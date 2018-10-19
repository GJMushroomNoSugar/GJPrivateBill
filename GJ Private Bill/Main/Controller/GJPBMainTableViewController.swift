//
//  GJPBMainTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SnapKit
import ToastSwiftFramework

let pullRefreshMsg = "下拉刷新"
let releaseUpdateMsg = "释放更新"
let loadingMsg = "加载中"

//所有信息刷新
let GJPBUPDATENOTIFICATION = "GJPBUPDATENOTIFICATION"

class GJPBMainTableViewController: UITableViewController {

    private var viewModel = GJPBMainViewModel()
    
    private lazy var totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#333333")
        label.text = "0"
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "GJPBAddRecord"), for: .normal)
        button.addTarget(self, action: #selector(createRecord), for: .touchUpInside)
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "今日账单"
        
        setupTableView()
        
        tableView.mj_header.beginRefreshing()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "全部账本", style: .done, target: self, action: #selector(rightClick))
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInfo), name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.view.addSubview(addButton)
        
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-94 - UIDevice.bottomHeight())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addButton.removeFromSuperview()
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = createHeaderView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(reloadInfo))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle(pullRefreshMsg, for: .idle)
        header?.setTitle(releaseUpdateMsg, for: .pulling)
        header?.setTitle(loadingMsg, for: .refreshing)
        tableView.mj_header = header
        
        tableView.registerCell(GJPBMainTableViewCell.self)
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 55))
        
        let nameMoneyLabel = UILabel()
        nameMoneyLabel.font = UIFont.systemFont(ofSize: 16)
        nameMoneyLabel.textColor = UIColor(hex: 0x333333)
        nameMoneyLabel.text = "今日结余: "
        headerView.addSubview(nameMoneyLabel)
        
        nameMoneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-10)
        }
        
        headerView.addSubview(totalMoneyLabel)
        
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameMoneyLabel.snp.right)
        }
        
        return headerView
    }
    
    @objc func rightClick() {
        navigationController?.pushViewController(GJPBAccountBookTableViewController(), animated: true)
    }
    
    @objc func createRecord() {
        //新建记录
        navigationController?.pushViewController(GJPBCreateRecordTableViewController(model: nil, successCourse: nil), animated: true)
    }
    
    @objc func reloadInfo() {
        
        self.noDataView.removeFromSuperview()
        
        //刷新数据
        viewModel.requestInfo(date:Date.string(date: Date(), dateFormatter: "yyyy-MM-dd"), success: { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
                self.reloadData()
            }
        })

    }
    
    func reloadData() {
        
        if viewModel.billModelArr.count == 0 {
            self.tableView.addSubview(self.noDataView)
            self.tableView.bringSubviewToFront(self.noDataView)
        }

        self.tableView.reloadData()
        self.totalMoneyLabel.text = viewModel.getTotalMoney()
        self.totalMoneyLabel.textColor = (Int(viewModel.getTotalMoney()) ?? 0) >= 0 ? UIColor(hex: "#225DFC"): UIColor.orange
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
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bill = viewModel.billModelArr[indexPath.row]
        
        navigationController?.pushViewController(GJPBRecordShowTableViewController(billModel: bill), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            viewModel.deleteRecord(id: viewModel.billModelArr[indexPath.row].id!, success: { [weak self] in
                self?.reloadInfo()
                self?.view.makeToast("删除成功")
            }) { [weak self] in
                self?.view.makeToast("删除失败")
            }
        }
    }
}
