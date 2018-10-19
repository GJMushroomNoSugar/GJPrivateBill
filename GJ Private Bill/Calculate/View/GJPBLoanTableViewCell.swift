//
//  GJPBLoanTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBLoanTableViewCellDataSource {
    var text: String? { get }
    var name: String { get }
    var placeholder: String { get }
}

class GJPBLoanTableViewCell: UITableViewCell, ReusableCell, UITextFieldDelegate {

    private var textEndEditing: ((_ text: String?) -> Void)?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#666666")
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(hex: "#666666")
        textField.delegate = self
        textField.tintColor = UIColor.mainColor()
        textField.textAlignment = .right
        textField.borderStyle = .line
        return textField;
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
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(25)
            make.width.equalTo(110)
        }
    }
    
    func configure(dataSource: GJPBLoanTableViewCellDataSource, textEndEditing: ((_ text: String?) -> Void)?) {
        nameLabel.text = dataSource.name
        textField.placeholder = dataSource.placeholder
        self.textEndEditing = textEndEditing
        textField.text = dataSource.text
    }
    
    //MARK: - UITextFieldDelegate
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
