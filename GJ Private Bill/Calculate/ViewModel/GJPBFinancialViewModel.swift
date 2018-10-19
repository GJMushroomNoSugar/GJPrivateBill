//
//  GJPBFinancialViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

struct GJPBFinancialViewModel {
    
    var money: String! = "1000"
    var time: String! = "1"
    var fee: String! = "3.5"
    
    private var indexPath: IndexPath?
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBFinancialViewModel {
        self.indexPath = indexPath
        return self
    }
}

extension GJPBFinancialViewModel: GJPBLoanTableViewCellDataSource {
    var text: String? {
        if indexPath?.row == 0 {
            return money
        }else if indexPath?.row == 1 {
            return fee
        }
        return time
    }
    
    var name: String {
        if indexPath?.row == 0 {
            return "存款金额 (元)"
        }else if indexPath?.row == 1 {
            return "年利率 (%)"
        }
        return "存款期限 (年)"
    }
    
    var placeholder: String {
        if indexPath?.row == 0 {
            return "0"
        }else if indexPath?.row == 1 {
            return "0"
        }
        return "0"
    }
}
