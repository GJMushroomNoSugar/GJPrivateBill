//
//  GJPBLoanViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import Foundation

struct GJPBLoanViewModel {
    
    var yearNum: String! = "1"
    var fee: String! = "3.5"
    var money: String! = "10"
    
    private var indexPath: IndexPath?
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBLoanViewModel {
        self.indexPath = indexPath
        return self
    }
}

extension GJPBLoanViewModel: GJPBLoanTableViewCellDataSource {
    var text: String? {
        if indexPath?.row == 0 {
            return money
        }else if indexPath?.row == 1 {
            return yearNum
        }
        return fee
    }
    
    var name: String {
        if indexPath?.row == 0 {
            return "贷款金额 (万元)"
        }else if indexPath?.row == 1 {
            return "贷款年限 (年)"
        }
        return "贷款利率 (%)"
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
