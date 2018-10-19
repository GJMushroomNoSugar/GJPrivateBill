//
//  GJPBMainViewModel.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

struct GJPBMainViewModel {

    private var indexPath: IndexPath?
    
    var billModelArr = [Bill]()
    
    mutating func cellMsg(indexPath: IndexPath) -> GJPBMainViewModel {
        self.indexPath = indexPath
        return self
    }

    public mutating func requestInfo(date: String, success: @escaping () -> ()) {
        let selfPointer = UnsafeMutablePointer(&self)
        GJPBDataManager.share.requestInfo(date: date, success: { (arr) in
            selfPointer.pointee.billModelArr = arr
            success()
        })
        
    }
    
    func getTotalMoney() -> String {
        
        if billModelArr.count == 0 {
            return "0"
        }
        
        var sum = "0"
        
        for bill in billModelArr {
            if bill.type == 1 {
                sum = sum.add(num: bill.money ?? "", eatEgg: .twoEgg)
            }else {
                sum = sum.subtrcing(num: bill.money ?? "", eatEgg: .twoEgg)
            }
        }
        return sum
    }

    //删除记录
    func deleteRecord(id: String, success: @escaping () -> (), fail: @escaping () -> ()) {
        GJPBDataManager.share.deleteBill(id: id, success: success, fail: fail)
    }
    
}

extension GJPBMainViewModel: GJPBMainTableViewCellDataSource {
    
    private func getBill() -> Bill? {
        
        guard let row = indexPath?.row else { return nil }
        
        return billModelArr[row]
    }
    
    var icon: UIImage {
        
        guard let bill = getBill() else { return UIImage() }
        
        return UIImage(named: bill.icon ?? "") ?? UIImage()
    }
    
    var name: String {
        return getBill()?.typeName ?? ""
    }
    
    var money: String {
        return getBill()?.money ?? ""
    }
    
    var moneyColor: UIColor {
        if getBill()?.type == 1 {
            return UIColor(hex: "#225DFC")
        }
        return UIColor.orange
    }
}
