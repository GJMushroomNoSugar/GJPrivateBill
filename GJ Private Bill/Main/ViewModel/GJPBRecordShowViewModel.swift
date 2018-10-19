//
//  GJPBRecordShowViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

struct GJPBRecordShowViewModel {

    var billModel: Bill
    
    private var indexPath: IndexPath?
    
    init(billModel: Bill) {
        self.billModel = billModel
    }
    
    var section: Int {
        return 1
    }
    
    func row(section: Int) -> Int {
        
        guard let desc = billModel.desc else {
            return 4
        }
        
        if desc.isEmpty {
            return 4
        }
        
        return 5
    }
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBRecordShowViewModel {
        self.indexPath = indexPath
        return self
    }
    
}

extension GJPBRecordShowViewModel: GJPBRecordShowMsgTableViewCellDataSource {
    var name: String {
        switch indexPath?.row {
        case 0:
            return "金额"
        case 1:
            return "收入/支出 类型"
        case 2:
            return "来路/用途"
        case 3:
            return "时间"
        case 4:
            return "描述"
        default:
            return ""
        }
    }
    
    var msg: String {
        switch indexPath?.row {
        case 0:
            return billModel.money ?? "" + "元"
        case 1:
            return billModel.type == 1 ? "收入": "支出"
        case 2:
            return billModel.typeName ?? ""
        case 3:
            return billModel.time ?? ""
        case 4:
            return billModel.desc ?? ""
        default:
            return ""
        }
    }
    
}
