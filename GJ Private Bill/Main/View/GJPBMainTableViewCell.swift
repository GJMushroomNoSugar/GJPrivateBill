//
//  GJPBMainTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol GJPBMainTableViewCellDataSource {
    var icon: UIImage { get }
    
    var name: String { get }
    
    var money: String { get }
    
    var moneyColor: UIColor { get }
}

class GJPBMainTableViewCell: UITableViewCell, ReusableCell {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#666666")
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
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(21.5)
            make.height.equalTo(17)
        }
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        addSubview(moneyLabel)
        
        moneyLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
        }
    }
    
    public func configure(dataSource: GJPBMainTableViewCellDataSource) {
        iconImageView.image = dataSource.icon
        nameLabel.text = dataSource.name
        moneyLabel.text = dataSource.money
        moneyLabel.textColor = dataSource.moneyColor
    }

}
