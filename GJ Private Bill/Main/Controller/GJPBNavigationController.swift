//
//  GJPBNavigationController.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBNavigationController: UINavigationController {

    class func setNavBar() {
        let navBar: UINavigationBar = UINavigationBar.appearance()
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.tintColor = UIColor.white
        navBar.barTintColor = UIColor.mainColor()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "GJPBBackArrow"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func navigationBack() {
        popViewController(animated: true)
    }

}
