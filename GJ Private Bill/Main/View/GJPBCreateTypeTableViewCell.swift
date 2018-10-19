//
//  GJPBCreateTypeTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBCreateTypeTableViewCellDataSource {
    var typeName: String { get }
    
    var typeMsg: String? { get }
}

class GJPBCreateTypeTableViewCell: UITableViewCell, ReusableCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var msgLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#225DFC")
        label.textAlignment = .right
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
        addSubview(msgLabel)
        msgLabel.snp.makeConstraints { (make) in
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
    
    public func configure(dataSource: GJPBCreateTypeTableViewCellDataSource) {
        nameLabel.text = dataSource.typeName
        msgLabel.text = dataSource.typeMsg
    }

}
