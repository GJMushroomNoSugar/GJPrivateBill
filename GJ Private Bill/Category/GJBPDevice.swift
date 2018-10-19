//
//  GJBPDevice.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

extension UIDevice {
    
    struct RuntimeKey {
        static let isIphoneXKey = UnsafeRawPointer.init(bitPattern: "isIphoneXKey".hashValue)
    }
    
    //屏幕高度
    public class func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    //屏幕宽度
    public class func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    //导航栏高度
    public class func navigationBarHeight() -> CGFloat {
        
        guard let isIphoneX = objc_getAssociatedObject(self, RuntimeKey.isIphoneXKey!) as? Bool else {
            
            objc_setAssociatedObject(self, RuntimeKey.isIphoneXKey!, screenHeight()/screenWidth() >= 2, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return screenHeight()/screenWidth() >= 2 ? 88: 64
        }
        
        return isIphoneX ? 88: 64
    }
    
    //底部高度
    public class func bottomHeight() -> CGFloat {
        
        guard let isIphoneX = objc_getAssociatedObject(self, RuntimeKey.isIphoneXKey!) as? Bool else {
            
            objc_setAssociatedObject(self, RuntimeKey.isIphoneXKey!, screenHeight()/screenWidth() >= 2, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return screenHeight()/screenWidth() >= 2 ? 34: 0
        }
        
        return isIphoneX ? 34: 0
    }
}

