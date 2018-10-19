//
//  GJPBFinancialTableViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBFinancialTableViewController: UITableViewController {
    
    private var viewModel = GJPBFinancialViewModel()
    
    private lazy var feeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.mainColor()
        label.textAlignment = .center
        label.text = "0.00"
        return label
    }()
    
    private lazy var totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.mainColor()
        label.textAlignment = .center
        label.text = "0.00"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        calculate()
    }
    
    func setupTable() {
        tableView.backgroundColor = UIColor(hex: "#f4f3f8")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = UIColor(hex: "#eaeaea")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = createHeaderView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerCell(GJPBLoanTableViewCell.self)
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.screenWidth(), height: 110))
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        headerView.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        let leftNameLabel = UILabel()
        leftNameLabel.text = "利息(元)"
        leftNameLabel.font = UIFont.systemFont(ofSize: 14)
        leftNameLabel.textColor = UIColor(hex: 0x666666)
        leftNameLabel.textAlignment = .center
        
        bottomView.addSubview(leftNameLabel)
        
        leftNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth() / 2)
            make.top.equalToSuperview().offset(15)
        }
        
        bottomView.addSubview(feeLabel)
        
        feeLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(leftNameLabel)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        let rightNameLabel = UILabel()
        rightNameLabel.text = "本息(元)"
        rightNameLabel.font = UIFont.systemFont(ofSize: 14)
        rightNameLabel.textColor = UIColor(hex: 0x666666)
        rightNameLabel.textAlignment = .center
        
        bottomView.addSubview(rightNameLabel)
        
        rightNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth() / 2)
            make.top.equalToSuperview().offset(15)
        }
        
        bottomView.addSubview(totalMoneyLabel)
        
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(rightNameLabel)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        return headerView
    }
    
    //计算
    private func calculate() {
        let lixi = viewModel.money.multiplyingby(num: viewModel.fee, eatEgg: nil).multiplyingby(num: viewModel.time, eatEgg: .twoEgg).dividingBy(num: "100", eatEgg: .twoEgg)
        
        feeLabel.text = lixi.moneyDeal()
        totalMoneyLabel.text = lixi.add(num: viewModel.money, eatEgg: .twoEgg).moneyDeal()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as GJPBLoanTableViewCell

        cell.configure(dataSource: viewModel.cellMsg(indexPath: indexPath)) { [weak self] (text) in
            if indexPath.row == 0 {
                self?.viewModel.money = text ?? ""
            }else if indexPath.row == 1 {
                self?.viewModel.fee = text ?? ""
            }else {
                self?.viewModel.time = text ?? ""
            }
            self?.calculate()
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
