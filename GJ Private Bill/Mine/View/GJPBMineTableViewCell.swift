//
//  GJPBMineTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBMineTableViewCell: UITableViewCell, ReusableCell {

    private lazy var nameLabel: UILabel = {
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
            make.height.equalTo(32)
        }
    }
    
    public func configure(color: UIColor, name: String?) {
        nameLabel.text = name
        nameLabel.textColor = color
    }

}
