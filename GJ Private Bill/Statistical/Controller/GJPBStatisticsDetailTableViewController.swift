//
//  GJPBStatisticsDetailTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBStatisticsDetailTableViewController: UITableViewController {

    private var model: GJPBAccountBookModel?
    
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //总收入
    private lazy var allIncomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        
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
        tableView.tableHeaderView = createHeaderView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBStatisticsDetailTableViewCell.self)
        
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 30))
        
        headerView.addSubview(allIncomeLabel)
        
        allIncomeLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        return headerView
    }
    
    @objc func reloadInfo() {
        self.noDataView.removeFromSuperview()
        GJPBDataManager.share.getTongjiDetail(date: time, type: type, name: name, success: { [weak self] (model) in
            self?.model = model
            self?.reloadData()
        }) {
            
        }
    }
    
    func reloadData() {
        
        if model?.list == nil || model?.list?.count == 0 {
            tableView.addSubview(noDataView)
            tableView.bringSubviewToFront(noDataView)
        }
        
        let str = "\(time) \(name) 共\(type == 1 ? "收入: ": "支出: ")\(type == 1 ? model?.allIncome ?? "": model?.allSpending ?? "")"
        
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : type == 1 ? UIColor(hex: "#225DFC"): UIColor.orange], range: NSRange(location: "\(time) \(name) 共\(type == 1 ? "收入: ": "支出: ")".count, length: (type == 1 ? model?.allIncome ?? "": model?.allSpending ?? "").count))
        allIncomeLabel.attributedText = attributeStr
        
        tableView.reloadData()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.list?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBStatisticsDetailTableViewCell
        
        cell.configure(time: model!.list![indexPath.row].time!, money: type == 1 ? model!.list![indexPath.row].income!: model!.list![indexPath.row].spending!, color: type == 1 ? UIColor(hex: "#225DFC"): UIColor.orange)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(GJPBStatisticsDayDetailTableViewController(type: type, time: model!.list![indexPath.row].time!, name: name), animated: true)
    }
}
