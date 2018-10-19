//
//  GJPBLoanTypeTableViewCell.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBLoanTypeTableViewCell: UITableViewCell, ReusableCell {

    private var loanTypeCourse: ((_ index: Int) -> Void)?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#666666")
        label.text = "贷款方式"
        return label
    }()
    
    private lazy var oneButton: UIButton = {
        let button = UIButton()
        button.setTitle("等额本息", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 85, height: 30)), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 85, height: 30)), for: .selected)
        button.tag = 101
        button.isSelected = true
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.layer.borderWidth = 1
        button.clipRectCorner(.allCorners, cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 85, height: 30))
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var twoButton: UIButton = {
        let button = UIButton()
        button.setTitle("等额本金", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 85, height: 30)), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 85, height: 30)), for: .selected)
        button.tag = 102
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.layer.borderWidth = 1
        button.clipRectCorner(.allCorners, cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 85, height: 30))
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        return button
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
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        addSubview(twoButton)
        
        twoButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(30)
        }
        
        addSubview(oneButton)
        
        oneButton.snp.makeConstraints { (make) in
            make.right.equalTo(twoButton.snp.left).offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(30)
        }
    }
    
    func configure(loanTypeCourse: @escaping ((_ index: Int) -> Void)) {
        self.loanTypeCourse = loanTypeCourse
    }
    
    @objc func buttonClick(button: UIButton) {
        
        if button.isSelected {
            return
        }
        
        let selected = button.tag == 101
        
        oneButton.isSelected = selected
        twoButton.isSelected = !selected
        loanTypeCourse?(button.tag)
        
    }

}
