//
//  GJPBStatisticalTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import Charts

class GJPBStatisticalTableViewController: UITableViewController {

    private var model: GJPBStatisticsModel?
    
    private var colorArr = [UIColor]()
    
    private var currentDate = Date.string(date: Date(), dateFormatter: "yyyy-MM")
    
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
    
    private lazy var chart: PieChartView = {
        
        let view = PieChartView(frame: CGRect(x: UIDevice.screenWidth()/2 - 289/2, y: 20, width: 289, height: 289))
        
        view.holeRadiusPercent = 0.0
        view.highlightPerTapEnabled = false
        view.legend.enabled = false
        view.chartDescription?.enabled = false
        view.drawHoleEnabled = false
        
        return view
    }()
    
    private lazy var headerInfoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 333, width: UIDevice.screenWidth(), height: 17))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#333333")
        
        return label
    }()
    
    private lazy var noneView: UIView = {
        
        let view = UIView(frame: CGRect(x: 15, y: 20, width: UIDevice.screenWidth() - 30, height: 289))
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "GJPBNoData")
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
        
        let label = UILabel()
        label.text = "暂无信息"
        view.addSubview(label)
        
        label.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(24)
        })
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        setupTableView()
        
        tableView.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInfo), name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
    }
    
    private func setupNav() {
        
        let navTitleView = UIView(frame: CGRect(x: 0, y: 11, width: 160, height: 22))
        
        navTitleView.addSubview(spendingButton)
        
        navTitleView.addSubview(incomeButton)
        
        navigationItem.titleView = navTitleView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: currentDate, style: UIBarButtonItem.Style.done, target: self, action: #selector(chooseDate))
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
        
        tableView.registerCell(GJPBStatisticsTableViewCell.self)
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 360))
        
        headerView.addSubview(chart)
        
        headerView.addSubview(headerInfoLabel)
        
        headerView.addSubview(noneView)
        
        return headerView
    }
    
    @objc func reloadInfo() {
        
        GJPBDataManager.share.getMonthPercentage(date:currentDate, success: { [weak self] (model) in
            self?.tableView.mj_header.endRefreshing()
            self?.model = model
            self?.reloadData()
        }) {

        }
    }
    
    func reloadData() {
        
        tableView.reloadData()
        let str = "\(currentDate)   " + (spendingButton.isSelected ? "总支出: \(model?.allSpending ?? "0")": "总收入: \(model?.allIncome ?? "0")")
        
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        if spendingButton.isSelected {
            attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 15, length: (model?.allSpending ?? "0").count))
        }else {
            attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#225DFC")], range: NSRange(location: 15, length: (model?.allIncome ?? "0").count))
        }
        
        headerInfoLabel.attributedText = attributeStr
        
        guard let arr = spendingButton.isSelected ? model?.spendingList: model?.incomeList else {
            noneView.isHidden = false
            return
        }
        
        if arr.count == 0 {
            noneView.isHidden = false
        }else {
            noneView.isHidden = true
        }
        
        while arr.count > colorArr.count {
            colorArr.append(UIColor.randomColor)
        }
        
        var pieList = [PieChartDataEntry]()
        
        for info in arr {
            pieList.append(PieChartDataEntry(value: Double(info.percentage ?? 0)))
        }
        
        let dataSet = PieChartDataSet(values: pieList, label: nil)
        dataSet.colors = colorArr
        
        let pieData = PieChartData(dataSets: [dataSet])
        pieData.setValueTextColor(UIColor.white)
        
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .percent
        nFormatter.maximumFractionDigits = 1
        pieData.setValueFormatter(DefaultValueFormatter(formatter: nFormatter))
        
        chart.data = pieData
        chart.data?.notifyDataChanged()
        chart.notifyDataSetChanged()
        chart.setNeedsDisplay()
        
        chart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
    }
    
    @objc func spendingButtonClick() {
        if spendingButton.isSelected {
            return
        }
        
        spendingButton.isSelected = true
        incomeButton.isSelected = false
        reloadInfo()
    }
    
    @objc func incomeButtonClick() {
        if incomeButton.isSelected {
            return
        }
        
        incomeButton.isSelected = true
        spendingButton.isSelected = false
        reloadInfo()
    }
    
    @objc func chooseDate() {
        let monthPicker = GJPBPickerView.init(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: UIDevice.screenHeight()), chooseType: .month(resultBack: { [weak self] (text) in
            self?.currentDate = text
            self?.navigationItem.rightBarButtonItem?.title = self?.currentDate
            self?.reloadInfo()
        }))
        monthPicker.show()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomeButton.isSelected ? (model?.incomeList?.count ?? 0): (model?.spendingList?.count ?? 0)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBStatisticsTableViewCell
        
        guard let arr = spendingButton.isSelected ? model?.spendingList: model?.incomeList else {
            return cell
        }
        
        cell.configure(color: colorArr[indexPath.row], name: arr[indexPath.row].name, money: arr[indexPath.row].money, moneyColor: spendingButton.isSelected ? UIColor.orange: UIColor(hex: "#225DFC"), prize: "\(String(format: "%.2f", (arr[indexPath.row].percentage ?? 0) * 100))%")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(GJPBStatisticsDetailTableViewController(type: spendingButton.isSelected ? 0: 1, time: currentDate, name: (spendingButton.isSelected ? model?.spendingList![indexPath.row].name: model?.incomeList![indexPath.row].name)!), animated: true)
    }
}
