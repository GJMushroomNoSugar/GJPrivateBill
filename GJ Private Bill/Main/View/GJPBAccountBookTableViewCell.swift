//
//  GJPBAccountBookTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBAccountBookTableViewCellDataSource {
    var name: String { get }
    
    var money: NSMutableAttributedString { get }
}

class GJPBAccountBookTableViewCell: UITableViewCell, ReusableCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#333333")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#666666")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.drawsAsynchronously = true
        accessoryType = .disclosureIndicator
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            
        }
        
        addSubview(moneyLabel)
        
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
        }
    }
    
    public func configure(dataSource: GJPBAccountBookTableViewCellDataSource) {
        nameLabel.text = dataSource.name
        moneyLabel.attributedText = dataSource.money
    }

}
