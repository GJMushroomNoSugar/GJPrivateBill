//
//  GJPBRecordModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

class GJPBRecordModel {
    var desc: String?
    
    var money: String?
    
    var time: String?
    
    var type: Int16?
    
    var typeName: String?
    
    var id: String?
    
    var icon: String?
    
    init(desc: String?, money: String?, time: String?, type: Int16?, typeName: String?, id: String?, icon: String?) {
        self.desc = desc
        self.money = money
        self.time = time
        self.type = type
        self.typeName = typeName
        self.id = id
        self.icon = icon
    }
}
