//
//  GJBPTableView.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

protocol ReusableCell : class{
    static var reuseableIdentifier :String {get}
    static var nib : UINib? {get}
}

extension ReusableCell where Self : UITableViewCell{
    static var reuseableIdentifier :String{
        return String(describing: self)
    }
    
    static var nib : UINib? {
        return nil
    }
}

extension UITableView{
    func registerCell<T : UITableViewCell >(_ cell : T.Type) where T : ReusableCell{
        if let nib  = T.nib{
            register(nib, forCellReuseIdentifier: T.reuseableIdentifier)
        }else{
            register(cell, forCellReuseIdentifier: T.reuseableIdentifier)
        }
    }
    
    func dequeReusableCell<T : UITableViewCell>(indexPath : IndexPath) -> T where T : ReusableCell{
        return dequeueReusableCell(withIdentifier: T.reuseableIdentifier, for: indexPath) as! T
    }
}
