//
//  GJPBChangeTypeTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBChangeTypeTableViewCell: UITableViewCell, ReusableCell {

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
        label.textColor = UIColor.mainColor()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "重命名"
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
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
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
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    public func configure(icon: String, name: String) {
        iconImageView.image = UIImage(named: icon)
        nameLabel.text = name
    }


}
