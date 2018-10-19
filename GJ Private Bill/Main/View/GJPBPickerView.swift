//
//  GJPBPickerView.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

enum GJPBPickerType {
    case month(resultBack: (_ date: String) -> ())
    case date(resultBack: (_ date: Date) -> ())
    case type(resultBack: (_ index: Int, _ title: String) -> Void)
}

protocol GJPBPickerViewDelegate {
    var componentNumber: Int { get }
    
    func row(component: Int, index: Int?) -> Int
    
    func title(row: Int, component: Int, index: Int?) -> String
    
    func didSelect(indexs: [Int])
    
    func didSelectDate(date: Date)
}

extension GJPBPickerType: GJPBPickerViewDelegate {
    var componentNumber: Int {
        switch self {
        case .month, .type:
            return 2
        default:
            return 1
        }
    }
    
    func row(component: Int, index: Int?) -> Int {
        switch self {
        case .month:
            if component == 0 {
                return Int(Date.string(date: Date(), dateFormatter: "yyyy")) ?? 2018
            }
            
            return 12
        case .type:
            if component == 0 {
                return 2
            }
            
            if index == 1 {
                return GJPBDataManager.share.incomeTypeArr.count
            }
            
            return GJPBDataManager.share.spendingTypeArr.count
            
        default:
            return 1
        }
    }
    
    func title(row: Int, component: Int, index: Int?) -> String {
        switch self {
        case .month:
            if component == 0 {
                return "\((Int(Date.string(date: Date(), dateFormatter: "yyyy")) ?? 2018) - row)年"
            }
            return "\(row + 1)月"
        case .type:
            if component == 0 {
                return ["支出", "收入"][row]
            }
            
            if index == 1 {
                return GJPBDataManager.share.incomeTypeArr[row].name ?? ""
            }
            
            return GJPBDataManager.share.spendingTypeArr[row].name ?? ""
            
        default:
            return ""
        }
    }
    
    func didSelect(indexs: [Int]) {
        switch self {
        case .month(let resultBack):
            resultBack("\((Int(Date.string(date: Date(), dateFormatter: "yyyy")) ?? 2018) - indexs.first!)-\(String(format: "%02d", indexs.last! + 1))")
        case .type(let resultBack):
            resultBack(indexs.first!, indexs.last == 1 ? GJPBDataManager.share.incomeTypeArr[indexs.last!].name ?? "": GJPBDataManager.share.spendingTypeArr[indexs.last!].name ?? "")
        default:
            break
        }
    }
    
    func didSelectDate(date: Date) {
        switch self {
        case .date(let resultBack):
            resultBack(date)
        default:
            break
        }
    }
}

class GJPBPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var chooseType: GJPBPickerType
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var datePick: UIDatePicker = {
        let datePick = UIDatePicker()
        datePick.locale = Locale(identifier: "zh_Hans_CN")
        datePick.calendar = Calendar.current
        datePick.date = Date()
        datePick.datePickerMode = .date
        return datePick
    }()
    
    private lazy var bgBlackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgBlackViewTap)))
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    init(frame: CGRect, chooseType: GJPBPickerType) {
        self.chooseType = chooseType
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        addSubview(bgBlackView)
        
        bgBlackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let height = UIDevice.screenWidth() == 320 ? 270: 310
        bottomView.frame = CGRect(x: 0, y: Int(UIDevice.screenHeight()), width: Int(UIDevice.screenWidth()), height: height)
        addSubview(bottomView)
        
        //取消按钮
        let cancleButton = UIButton()
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor.mainColor(), for: .normal)
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        bottomView.addSubview(cancleButton)
        
        cancleButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        
        //完成按钮
        let confirmButton = UIButton()
        confirmButton.setTitle("完成", for: .normal)
        confirmButton.setTitleColor(UIColor.mainColor(), for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        bottomView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.top.equalTo(cancleButton)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "#eaeaea")
        bottomView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(cancleButton.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        switch chooseType {
        case .date:
            bottomView.addSubview(datePick)
            
            datePick.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(lineView.snp.bottom)
            }
        default:
            bottomView.addSubview(pickerView)
            
            pickerView.snp.makeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalTo(lineView.snp.bottom)
            }
        }
    }
    
    func show() {
        //此处应有动画
        UIApplication.shared.keyWindow?.addSubview(self)
        showAnimate()
    }
    
    //MARK: - 点击事件
    //点击背景
    @objc func bgBlackViewTap() {
        dismissAnimate()
    }
    
    //取消按钮点击
    @objc func cancleButtonClick() {
        dismissAnimate()
    }
    
    //完成按钮点击
    @objc func confirmButtonClick() {
        
        switch chooseType {
        case .date:
            chooseType.didSelectDate(date: datePick.date)
        case .month, .type:
            chooseType.didSelect(indexs: [pickerView.selectedRow(inComponent: 0), pickerView.selectedRow(inComponent: 1)])
        }
        
        dismissAnimate()
    }
    
    //MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return chooseType.componentNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return chooseType.row(component: component, index: nil)
        }
        
        return chooseType.row(component: component, index: pickerView.selectedRow(inComponent: 0))
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: Int(width) / chooseType.componentNumber, height: 42))
        
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#666666")
        
        if component == 0 {
            label.text = chooseType.title(row: row, component: component, index: nil)
        }else {
             label.text = chooseType.title(row: row, component: component, index: pickerView.selectedRow(inComponent: 0))
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 42
    }
    
    //MARK: - 动画
    func showAnimate() {
        let height = UIDevice.screenWidth() == 320 ? 270: 310
        UIView.animate(withDuration: 0.6) {
            self.bgBlackView.alpha = 0.5
            self.bottomView.y = UIDevice.screenHeight() - CGFloat(height)
        }
    }
    
    func dismissAnimate() {
        UIView.animate(withDuration: 0.6, animations: {
            self.bgBlackView.alpha = 0
            self.bottomView.y = UIDevice.screenHeight()
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
