//
//  GJPBMonthBookViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/17.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

struct GJPBMonthBookViewModel {
    
    let year: String
    
    init(year: String) {
        self.year = year
    }
    
    var model: GJPBAccountBookModel?
    
    private var indexPath: IndexPath?
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBMonthBookViewModel {
        self.indexPath = indexPath
        return self
    }
    
    mutating func getMonthRecord(success: @escaping () -> (), fail: @escaping () -> ()) {
        let selfPointer = UnsafeMutablePointer(&self)
        GJPBDataManager.share.getMonthRecord(date: year, success: { (model) in
            selfPointer.pointee.model = model
            success()
        }, fail: fail)
    }
    
}

extension GJPBMonthBookViewModel: GJPBAccountBookTableViewCellDataSource {
    
    private func getInfo() -> GJPBAccountBookListModel? {
        return model?.list?[indexPath?.row ?? 0]
    }
    
    var name: String {
        return getInfo()?.time ?? ""
    }
    
    var money: NSMutableAttributedString {
        let str = "收入：\(getInfo()?.income ?? "0")   支出：\(getInfo()?.spending ?? "0")"
        
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(hex: "#225DFC")], range: NSRange(location: 3, length: (getInfo()?.income ?? "0").count))
        attributeStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], range: NSRange(location: 9 + (getInfo()?.income ?? "0").count, length: (getInfo()?.spending ?? "0").count))
        return attributeStr
        
    }
}
