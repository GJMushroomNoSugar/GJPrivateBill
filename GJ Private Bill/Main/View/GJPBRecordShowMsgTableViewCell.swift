//
//  GJPBRecordShowMsgTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBRecordShowMsgTableViewCellDataSource {
    var name: String { get }
    
    var msg: String { get }
}

class GJPBRecordShowMsgTableViewCell: UITableViewCell, ReusableCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#666666")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.drawsAsynchronously = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(150)
        }
        
        addSubview(msgLabel)
        
        msgLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    public func configure(dataSource: GJPBRecordShowMsgTableViewCellDataSource) {
        nameLabel.text = dataSource.name
        msgLabel.text = dataSource.msg
    }
}
