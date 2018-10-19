//
//  GJPBAddTypeCollectionViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBAddTypeCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.drawsAsynchronously = true
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
}
