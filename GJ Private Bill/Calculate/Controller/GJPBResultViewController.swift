//
//  GJPBResultViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBResultViewController: UIViewController {

    let loanType: BILLLoanType
    let money: String
    let time: String
    let fee: String
    
    init(loanType: BILLLoanType, money: String, time: String, fee: String) {
        self.loanType = loanType
        self.money = money
        self.time = time
        self.fee = fee
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#f4f3f8")
        navigationItem.title = "计算结果"
        setupUI()
    }
    
    private func setupUI() {
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        let firstMonthNameLabel = UILabel()
        firstMonthNameLabel.font = UIFont.systemFont(ofSize: 14)
        firstMonthNameLabel.textColor = UIColor(hex: 0x666666)
        firstMonthNameLabel.text = "首月月供"
        bottomView.addSubview(firstMonthNameLabel)
        
        firstMonthNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
        }
        
        let firstMonthLabel = UILabel()
        firstMonthLabel.font = UIFont.systemFont(ofSize: 18)
        firstMonthLabel.textColor = UIColor.mainColor()
        firstMonthLabel.text = firthMonthMoney()
        bottomView.addSubview(firstMonthLabel)
        
        firstMonthLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstMonthNameLabel)
            make.top.equalTo(firstMonthNameLabel.snp.bottom).offset(6)
        }
        
        let leftNameLabel = UILabel()
        leftNameLabel.font = UIFont.systemFont(ofSize: 13)
        leftNameLabel.textColor = UIColor(hex: 0x666666)
        leftNameLabel.text = "贷款总额"
        leftNameLabel.textAlignment = .center
        bottomView.addSubview(leftNameLabel)
        
        leftNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(UIDevice.screenWidth() / 3)
            make.top.equalTo(firstMonthLabel.snp.bottom).offset(19)
        }
        
        let leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textColor = UIColor.mainColor()
        leftLabel.text = "\(money)".multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal() + "元"
        bottomView.addSubview(leftLabel)
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(leftNameLabel)
            make.top.equalTo(leftNameLabel.snp.bottom).offset(12.5)
        }
        
        let centerNameLabel = UILabel()
        centerNameLabel.font = UIFont.systemFont(ofSize: 13)
        centerNameLabel.textColor = UIColor(hex: 0x666666)
        centerNameLabel.text = "利率"
        centerNameLabel.textAlignment = .center
        bottomView.addSubview(centerNameLabel)
        
        centerNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftNameLabel.snp.right)
            make.width.equalTo(UIDevice.screenWidth() / 3)
            make.top.equalTo(firstMonthLabel.snp.bottom).offset(19)
        }
        
        let centerLabel = UILabel()
        centerLabel.font = UIFont.systemFont(ofSize: 16)
        centerLabel.textColor = UIColor.mainColor()
        centerLabel.text = "\(fee)%"
        bottomView.addSubview(centerLabel)
        
        centerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(centerNameLabel)
            make.top.equalTo(centerNameLabel.snp.bottom).offset(12.5)
        }
        
        let rightNameLabel = UILabel()
        rightNameLabel.font = UIFont.systemFont(ofSize: 13)
        rightNameLabel.textColor = UIColor(hex: 0x666666)
        rightNameLabel.text = "贷款年限"
        rightNameLabel.textAlignment = .center
        bottomView.addSubview(rightNameLabel)
        
        rightNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(centerNameLabel.snp.right)
            make.width.equalTo(UIDevice.screenWidth() / 3)
            make.top.equalTo(firstMonthLabel.snp.bottom).offset(19)
        }
        
        let rightLabel = UILabel()
        rightLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.textColor = UIColor.mainColor()
        rightLabel.text = "\(time)年"
        bottomView.addSubview(rightLabel)
        
        rightLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(rightNameLabel)
            make.top.equalTo(rightNameLabel.snp.bottom).offset(12.5)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xdadada)
        bottomView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightLabel.snp.bottom).offset(12.5)
            make.height.equalTo(0.5)
        }
        
        let totalFeeNameLabel = UILabel()
        totalFeeNameLabel.font = UIFont.systemFont(ofSize: 13)
        totalFeeNameLabel.textColor = UIColor(hex: 0x666666)
        totalFeeNameLabel.text = "累计利息(元)"
        bottomView.addSubview(totalFeeNameLabel)
        
        totalFeeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(20)
            make.left.equalTo(firstMonthLabel)
        }
        
        let totalFeeLabel = UILabel()
        totalFeeLabel.font = UIFont.systemFont(ofSize: 14)
        totalFeeLabel.textColor = UIColor.mainColor()
        totalFeeLabel.text = totalFee()
        bottomView.addSubview(totalFeeLabel)
        
        totalFeeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalFeeNameLabel.snp.right).offset(10)
            make.centerY.equalTo(totalFeeNameLabel)
        }
        
        let totalMoneyNameLabel = UILabel()
        totalMoneyNameLabel.font = UIFont.systemFont(ofSize: 13)
        totalMoneyNameLabel.textColor = UIColor(hex: 0x666666)
        totalMoneyNameLabel.text = "累计还款金额(元)"
        bottomView.addSubview(totalMoneyNameLabel)
        
        totalMoneyNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(totalFeeNameLabel.snp.bottom).offset(20)
            make.left.equalTo(totalFeeNameLabel)
        }
        
        let totalMoneyLabel = UILabel()
        totalMoneyLabel.font = UIFont.systemFont(ofSize: 14)
        totalMoneyLabel.textColor = UIColor.mainColor()
        totalMoneyLabel.text = totalMoney()
        bottomView.addSubview(totalMoneyLabel)
        
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalMoneyNameLabel.snp.right).offset(10)
            make.centerY.equalTo(totalMoneyNameLabel)
        }
    }
    
    private func firthMonthMoney() -> String {
        
        if loanType == .interest {
            let dFee = (Double(fee) ?? 0.0) / 100
            let monthFee = dFee / 12.0
            let monthNum = (Double(time) ?? 0.0) * 12
            
            let result = (Double(money) ?? 0.0) * monthFee * pow(1 + monthFee, monthNum) / (pow(1 + monthFee, monthNum) - 1)
            return "¥" + "\(String.init(format: "%.6f", result))".multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal() + "元"
        }
        
        let firstFee = money.multiplyingby(num: fee, eatEgg: nil).dividingBy(num: "12", eatEgg: nil).dividingBy(num: "100", eatEgg: nil)
        let monthNum = time.multiplyingby(num: "12", eatEgg: nil)
        return "¥" + money.dividingBy(num: monthNum, eatEgg: nil).add(num: firstFee, eatEgg: .otherEgg(index: 6)).multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal() + "元"
    }
    
    private func totalFee() -> String {
        
        if loanType == .interest {
            let dFee = (Double(fee) ?? 0.0) / 100
            let monthFee = dFee / 12.0
            let monthNum = (Double(time) ?? 0.0) * 12
            
            let monthMonth = (Double(money) ?? 0.0) * monthFee * pow(1 + monthFee, monthNum) / (pow(1 + monthFee, monthNum) - 1)
            
            let result = monthMonth * (Double(time) ?? 0.0) * 12 - (Double(money) ?? 0.0)
            return "\(String.init(format: "%.6f", result))".multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal()
        }
        let dFee = (Double(fee) ?? 0.0) / 100
        let monthFee = dFee / 12.0
        let monthNum = (Double(time) ?? 1) * 12 + 1
        let result = (Double(money) ?? 0.0) * monthNum * monthFee / 2
        
        return "\(String.init(format: "%.6f", result))".multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal()
    }
    
    private func totalMoney() -> String {
        if loanType == .interest {
            let dFee = (Double(fee) ?? 0.0) / 100
            let monthFee = dFee / 12.0
            let monthNum = (Double(time) ?? 0.0) * 12
            
            let monthMonth = (Double(money) ?? 0.0) * monthFee * pow(1 + monthFee, monthNum) / (pow(1 + monthFee, monthNum) - 1)
            
            let result = monthMonth * (Double(time) ?? 0.0) * 12
            return "\(String.init(format: "%.6f", result))".multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal()
        }
        
        let dFee = (Double(fee) ?? 0.0) / 100
        let monthFee = dFee / 12.0
        let monthNum = (Double(time) ?? 1) * 12 + 1
        let result = (Double(money) ?? 0.0) * monthNum * monthFee / 2
        
        return money.add(num: "\(String.init(format: "%.6f", result))", eatEgg: .otherEgg(index: 6)).multiplyingby(num: "10000", eatEgg: .twoEgg).moneyDeal()
    }
    

   

}
