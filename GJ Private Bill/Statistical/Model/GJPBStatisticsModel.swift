//
//  GJPBStatisticsModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

struct GJPBStatisticsModel {
    var allIncome: String?
    
    var allSpending: String?
    
    var incomeList: [GJPBStatisticsListModel]?
    
    var spendingList: [GJPBStatisticsListModel]?
}

class GJPBStatisticsListModel {
    var money: String?
    
    var name: String?
    
    var percentage: Float?
}
