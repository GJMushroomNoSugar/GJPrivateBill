//
//  GJPBCreateRecordViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import SCLAlertView

struct GJPBCreateRecordViewModel {

    var billModel: Bill?
    
    var recordModel: GJPBRecordModel?
    
    private var indexPath: IndexPath?
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBCreateRecordViewModel {
        self.indexPath = indexPath
        return self
    }
    
    mutating func canSavs() -> Bool {
        
        if billModel == nil {
            
            if recordModel?.money == nil || recordModel?.money?.count == 0 || recordModel?.typeName == nil {
                
                let alertView = SCLAlertView(appearance: sclAppearance)
                alertView.addButton("好的") {
                    
                }
                alertView.showWarning("提示", subTitle: "金钱数额和类型是必填的")
                
                return false
            }
            
            recordModel?.icon = recordModel?.type == 1 ? GJPBDataManager.share.findIncomeIcon(name: recordModel!.typeName!): GJPBDataManager.share.findSpendingIcon(name: recordModel!.typeName!)
            
            if recordModel?.time == nil {
                recordModel?.time = Date.string(date: Date(), dateFormatter: "yyyy-MM-dd")
            }
        }else {
        
            if billModel?.money == nil || billModel?.money?.count == 0 || billModel?.typeName == nil {
                
                let alertView = SCLAlertView(appearance: sclAppearance)
                alertView.addButton("好的") {
                    
                }
                alertView.showWarning("提示", subTitle: "金钱数额和类型是必填的")
                
                return false
            }
            
            billModel?.icon = billModel?.type == 1 ? GJPBDataManager.share.findIncomeIcon(name: billModel!.typeName!): GJPBDataManager.share.findSpendingIcon(name: billModel!.typeName!)
            
            if billModel?.time == nil {
                billModel?.time = Date.string(date: Date(), dateFormatter: "yyyy-MM-dd")
            }
        }
        
        return true
    }
    
    
    //添加
    mutating func add(success: @escaping () -> (), fail: @escaping () -> ()) {
        
        if !canSavs() {
            return
        }
        
        GJPBDataManager.share.add(model: recordModel!, success: success, fail: fail)
    }
    
    //修改
    mutating func change(success: @escaping () -> (), fail: @escaping () -> ()) {
        
        if !canSavs() {
            return
        }
        
        GJPBDataManager.share.change(model: billModel!, success: success, fail: fail)
    }
}

extension GJPBCreateRecordViewModel: GJPBCreateMoneyTableViewCellDataSource {
    var placeholder: String {
        return "请输入金额"
    }
    
    var courceName: String {
        return "金额"
    }
    
    var text: String? {
        return billModel?.money ?? recordModel?.money
    }
}

extension GJPBCreateRecordViewModel: GJPBCreateTypeTableViewCellDataSource {
    var typeName: String {
        
        if indexPath?.row == 1 {
            return "类型"
        }
        
        return "日期"
    }
    
    var typeMsg: String? {
        if indexPath?.row == 1 {
            return billModel?.typeName ?? recordModel?.typeName ?? "点击输入"
        }
        
        return billModel?.time ?? recordModel?.time ?? Date.string(date: Date(), dateFormatter: "yyyy-MM-dd")
    }
}

extension GJPBCreateRecordViewModel: GJPBCreateDescTableViewCellDataSource {
    var descPlaceholder: String {
        return "请输入备注"
    }
    
    var descText: String? {
        return billModel?.desc ?? recordModel?.desc
    }
}

