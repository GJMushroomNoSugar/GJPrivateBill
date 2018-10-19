//
//  GJPBAccountBookTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBAccountBookTableViewController: UITableViewController {

    private var viewModel = GJPBAccountBookViewModel()
    
    //总收入
    private lazy var allIncomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        
        let str = "总收入：0  总支出：0"
        
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#225DFC")], range: NSRange(location: 4, length: 1))
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 11, length: 1))
        label.attributedText = attributeStr
        return label
    }()
    
    //结余
    private lazy var restLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(hex: 0x999999)
        label.text = "结余: 0"
        return label
    }()
    
    private lazy var noDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 70, width: UIDevice.screenWidth(), height: UIDevice.screenHeight() - 200))
        
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
        
        navigationItem.title = "全部账本记录"
        
        setupTableView()
        
        tableView.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInfo), name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
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
        
        tableView.registerCell(GJPBAccountBookTableViewCell.self)
        
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 70))
        
        headerView.addSubview(allIncomeLabel)
        
        allIncomeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        headerView.addSubview(restLabel)
        
        restLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(allIncomeLabel.snp.bottom).offset(8)
        }
        
        return headerView
    }
    
    @objc func reloadInfo() {
        
        self.noDataView.removeFromSuperview()
        
        //刷新数据
        viewModel.getAllRecord(success: { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
                self.reloadData()
            }
        }) {
            
        }
    }
    
    func reloadData() {
        
        if viewModel.model?.list == nil || viewModel.model?.list?.count == 0 {
            tableView.addSubview(noDataView)
            tableView.bringSubviewToFront(noDataView)
        }

        tableView.reloadData()
        restLabel.text = "结余: " + (viewModel.model?.rest ?? "0")

        let str = "总收入：\(viewModel.model?.allIncome ?? "0")  总支出：\(viewModel.model?.allSpending ?? "0")"

        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#225DFC")], range: NSRange(location: 4, length: (viewModel.model?.allIncome ?? "0").count))
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 10 + (viewModel.model?.allIncome ?? "0").count, length: (viewModel.model?.allSpending ?? "0").count))
        allIncomeLabel.attributedText = attributeStr
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.model?.list?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBAccountBookTableViewCell

        cell.configure(dataSource: viewModel.cellMsg(indexPath: indexPath))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(GJPBMonthBookTableViewController(year: viewModel.model!.list![indexPath.row].time ?? ""), animated: true)
    }

}
