//
//  GJPBCreateDescTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBCreateDescTableViewCellDataSource {
    var descPlaceholder: String { get }
    
    var descText: String? { get }
}

class GJPBCreateDescTableViewCell: UITableViewCell, ReusableCell, UITextViewDelegate {
    
    private var textEndEditing: ((_ text: String?) -> Void)?
    
    public lazy var textField: UITextView = {
        let textField = UITextView()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor(hex: "#225DFC")
        textField.tintColor = UIColor.mainColor()
        textField.delegate = self
        return textField
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
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
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(100)
        }
        
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textField).offset(5)
            make.top.equalTo(textField).offset(8)
        }
    }
    
    public func configure(dataSource: GJPBCreateDescTableViewCellDataSource, textEndEditing: ((_ text: String?) -> Void)?) {
        self.textEndEditing = textEndEditing
        placeholderLabel.text = dataSource.descPlaceholder
        textField.text = dataSource.descText
        if (dataSource.descText ?? "").count > 0 {
            placeholderLabel.isHidden = true
        }else {
            placeholderLabel.isHidden = false
        }
    }
    
    //MARK: -- UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text ?? "").count > 0 {
            placeholderLabel.isHidden = true
        }else {
            placeholderLabel.isHidden = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textEndEditing == nil {
            return
        }
        textEndEditing!(textField.text)
    }
}
