//
//  GJPBTabBarController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        GJPBDataManager.share.begin()
        addChild(GJPBMainTableViewController(), title: "记账", imageName: "GJPBTabMain")
        addChild(GJPBCalculateViewController(), title: "计算", imageName: "GJPBTabCalculate")
        addChild(GJPBStatisticalTableViewController(), title: "统计", imageName: "GJPBTabStatistical")
        addChild(GJPBMineTableViewController(), title: "我的", imageName: "GJPBTabMine")
    }
    
    func addChild(_ childController: UIViewController, title: String, imageName: String) {
        childController.tabBarItem.title = title
        childController.tabBarItem.image = UIImage(named: imageName + "Normal")?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "Selected")?.withRenderingMode(.alwaysOriginal)
        
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], for: .normal)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.mainColor()], for: .selected)
        childController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: 0x333333)], for: .normal)
        
        addChild(GJPBNavigationController(rootViewController: childController))
    }

}
