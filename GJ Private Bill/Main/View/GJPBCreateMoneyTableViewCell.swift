//
//  GJPBCreateMoneyTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBCreateMoneyTableViewCellDataSource {
    var placeholder: String { get }
    var courceName: String { get }
    var text: String? { get }
}

class GJPBCreateMoneyTableViewCell: UITableViewCell, ReusableCell, UITextFieldDelegate {

    private var textEndEditing: ((_ text: String?) -> Void)?
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.textAlignment = .right
        textField.textColor = UIColor(hex: "#225DFC")
        textField.tintColor = UIColor.mainColor()
        textField.delegate = self
        return textField
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.drawsAsynchronously = true
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(105)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(32)
        }
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
    }
    
    public func configure(dataSource: GJPBCreateMoneyTableViewCellDataSource, textEndEditing: ((_ text: String?) -> Void)?) {
        self.textEndEditing = textEndEditing
        nameLabel.text = dataSource.courceName
        textField.placeholder = dataSource.placeholder;
        textField.text = dataSource.text
    }
    
    //MARK: -- UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textEndEditing == nil {
            return
        }
        textEndEditing!(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
