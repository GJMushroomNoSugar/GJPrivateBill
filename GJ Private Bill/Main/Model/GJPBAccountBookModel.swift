//
//  GJPBAccountBookModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

struct GJPBAccountBookModel {
    
    var allIncome: String?
    
    var allSpending: String?
    
    var rest: String?
    
    var list: [GJPBAccountBookListModel]?
}

class GJPBAccountBookListModel {
    
    var time: String?
    
    var income: String?
    
    var spending: String?
    
}
