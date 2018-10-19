//
//  GJPBStatisticsTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBStatisticsTableViewCell: UITableViewCell, ReusableCell {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipRectCorner(.allCorners, cornerRadius: 11.5, roundedRect: CGRect.init(x: 0, y: 0, width: 23, height: 23))
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
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#666666")
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
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
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(23)
            make.height.equalTo(23)
        }
        
        addSubview(moneyLabel)
        
        moneyLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(moneyLabel.snp.left)
        }
        
        addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
            make.left.equalTo(moneyLabel.snp.right)
        }
        
        
    }
    
    public func configure(color: UIColor, name: String?, money: String?, moneyColor: UIColor, prize: String?) {
        iconImageView.backgroundColor = color
        nameLabel.text = name
        moneyLabel.text = money
        moneyLabel.textColor = moneyColor
        priceLabel.text = prize
    }

}
