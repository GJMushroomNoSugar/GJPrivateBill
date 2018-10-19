//
//  GJPBAddTypeViewController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SCLAlertView

class GJPBAddTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let iconArr = ["GJPBEat", "GJPBCar", "GJPBPackage", "GJPBClothes", "GJPBDoctorialHat", "GJPBRedWine", "GJPBHouse", "GJPBShopping", "GJPBTreadmill", "GJPBMobile", "GJPBCosmetics", "GJPBMedicineCabinet", "GJPBConsole", "GJPBPlane", "GJPBGasStation", "GJPBIntegralCharity", "GJPBGoldCOINS", "GJPBCurrency", "GJPBPurse", "GJPBCalculator", "GJPBTrend", "GJPBDollar", "GJPBPiggyBank", "GJPBGoldCOINSAdd"]
    
    private var currentIndex = 0
    
    //支出按钮
    private lazy var spendingButton: UIButton = {
        let button = UIButton()
        button.setTitle("支出", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 55, height: 22)), for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 55, height: 22)), for: .normal)
        button.isSelected = true
        button.addTarget(self, action: #selector(spendingButtonClick), for: .touchUpInside)
        button.clipRectCorner([.bottomLeft, .topLeft], cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 55, height: 22))
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    
    //收入按钮
    private lazy var incomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("收入", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .selected)
        button.setTitleColor(UIColor.mainColor(), for: .normal)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.mainColor(), size: CGSize(width: 55, height: 22)), for: .selected)
        button.setBackgroundImage(UIImage().image(withColor: UIColor.white, size: CGSize(width: 55, height: 22)), for: .normal)
        button.addTarget(self, action: #selector(incomeButtonClick), for: .touchUpInside)
        button.clipRectCorner([.bottomRight, .topRight], cornerRadius: 2, roundedRect: CGRect(x: 0, y: 0, width: 55, height: 22))
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var currentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: iconArr[currentIndex])
        return imageView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "请输入新类别名称"
        
        return textField
    }()
    
    let GJPBAddTypeViewControllerID = "GJPBAddTypeViewControllerID"
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIDevice.screenWidth() / 4 - 10, height: 80)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: UIDevice.screenWidth(), height: UIDevice.screenHeight() - 55 - UIDevice.navigationBarHeight()), collectionViewLayout: flowLayout)
        collectionView.register(GJPBAddTypeCollectionViewCell.self, forCellWithReuseIdentifier: GJPBAddTypeViewControllerID)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hex: "#f4f3f8")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#f4f3f8")
        navigationItem.title = "添加类别"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItem.Style.done, target: self, action: #selector(save))
        
        setupUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "GJPBBackArrow"), style: .plain, target: self, action: #selector(navigationBack))
    }
    
    private func setupUI() {
        view.addSubview(spendingButton)
        
        spendingButton.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.width.equalTo(55)
            make.height.equalTo(22)
        }
        
        view.addSubview(incomeButton)
        
        incomeButton.snp.makeConstraints { (make) in
            make.left.equalTo(spendingButton.snp.right)
            make.width.height.centerY.equalTo(spendingButton)
        }
        
        view.addSubview(currentIcon)
        
        currentIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(spendingButton)
            make.left.equalTo(incomeButton.snp.right).offset(10)
            make.width.equalTo(25)
            make.height.equalTo(22)
        }
        
        view.addSubview(nameTextField)
        
        nameTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(spendingButton)
            make.left.equalTo(currentIcon.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(24)
        }
        
        view.addSubview(collectionView)
    }
    
    
    
    @objc func save() {
        view.endEditing(true)
        
        if nameTextField.text == nil || nameTextField.text?.count == 0 {
            let alertView = SCLAlertView(appearance: sclAppearance)
            alertView.addButton("好的") {
                
            }
            alertView.showWarning("提示", subTitle: "类别名称是必填的")
            return
        }
        
        if spendingButton.isSelected {
            for info in GJPBDataManager.share.spendingTypeArr {
                if info.name == nameTextField.text! {
                    let alertView = SCLAlertView(appearance: sclAppearance)
                    alertView.addButton("好的") {
                        
                    }
                    alertView.showWarning("提示", subTitle: "该类别名称已存在")
                    return
                }
            }
        }else {
            for info in GJPBDataManager.share.incomeTypeArr {
                if info.name == nameTextField.text! {
                    let alertView = SCLAlertView(appearance: sclAppearance)
                    alertView.addButton("好的") {
                        
                    }
                    alertView.showWarning("提示", subTitle: "该类别名称已存在")
                    return
                }
            }
        }
        
        GJPBDataManager.share.addType(name: nameTextField.text!, type: spendingButton.isSelected ? 0: 1, icon: iconArr[currentIndex], success: { [weak self] in
            let alertView = SCLAlertView(appearance: sclAppearance)
            alertView.addButton("好的") {
                if self!.spendingButton.isSelected {
                    GJPBDataManager.share.getSpendingTypeArr()
                }else {
                    GJPBDataManager.share.getIncomeTypeArr()
                }

                self?.navigationController?.popViewController(animated: true)
            }
            alertView.showWarning("提示", subTitle: "成功")
        }) {
            let alertView = SCLAlertView(appearance: sclAppearance)
            alertView.addButton("好的") {
                
            }
            alertView.showWarning("提示", subTitle: "保存失败")
        }
    }
    
    @objc func navigationBack() {
        
        view.endEditing(true)
        
        if nameTextField.text == nil || nameTextField.text?.count == 0 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let alertView = SCLAlertView(appearance: sclAppearance)
        alertView.addButton("取消") {
            
        }
        alertView.addButton("返回") {
            self.navigationController?.popViewController(animated: true)
        }
        alertView.showWarning("提醒", subTitle: "还未保存, 是否返回?")
    }
    
    @objc func spendingButtonClick() {
        if spendingButton.isSelected {
            return
        }
        
        spendingButton.isSelected = true
        incomeButton.isSelected = false
    }
    
    @objc func incomeButtonClick() {
        if incomeButton.isSelected {
            return
        }
        
        incomeButton.isSelected = true
        spendingButton.isSelected = false
    }
    
    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GJPBAddTypeViewControllerID, for: indexPath) as! GJPBAddTypeCollectionViewCell
        cell.imageView.image = UIImage(named: iconArr[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.item
        currentIcon.image = UIImage(named: iconArr[currentIndex])
    }

}
