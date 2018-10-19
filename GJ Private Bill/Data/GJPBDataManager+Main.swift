//
//  GJPBDataManager+Main.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/16.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import CoreData

extension GJPBDataManager {
    
    //查询某一天数据
    func requestInfo(date: String, success: @escaping (_ billModelArr: [Bill]) -> ()) {
        
        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"time == '\(date)'")
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            if fetchedObjects.count == 0 {
                success([Bill]())
            }else {
                success(fetchedObjects)
            }
            
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    //删除记录
    func deleteBill(id: String, success: @escaping () -> (), fail: @escaping () -> ()) {

        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"id == '\(id)'")
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            for info in fetchedObjects {
                myContext.delete(info)
            }
            NotificationCenter.default.post(name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
            success()
            
        } catch {
            fail()
            fatalError("不能查询：\(error)")
        }
    }
    
    //修改记录
    func change(model: Bill, success: @escaping () -> (), fail: @escaping () -> ()) {

        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"id == '\(model.id!)'")
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            for bill in fetchedObjects {
                bill.typeName = model.typeName
                bill.desc = model.desc
                bill.money = model.money
                bill.type = model.type
                bill.time = model.time
                bill.icon = model.icon
            }
            try myContext.save()
            NotificationCenter.default.post(name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
            success()
            
        } catch {
            fail()
            fatalError("不能查询：\(error)")
        }
    }
    
    //增加记录
    func add(model: GJPBRecordModel, success: @escaping () -> (), fail: @escaping () -> ()) {
        let bill = NSEntityDescription.insertNewObject(forEntityName: "Bill", into: myContext) as! Bill
        
        bill.typeName = model.typeName
        bill.desc = model.desc
        bill.money = model.money
        bill.type = model.type!
        bill.time = model.time ?? Date.string(date: Date(), dateFormatter: "yyyy-MM-dd")
        bill.id = UUID().uuidString
        bill.icon = model.icon
        
        //保存
        do {
            try myContext.save()
            NotificationCenter.default.post(name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
            success()
        } catch {
            fail()
            fatalError("不能保存：\(error)")
        }
    }
    
    //获取全部账本记录
    func getAllRecord(success: @escaping (_ billModelArr: GJPBAccountBookModel) -> (), fail: @escaping () -> ()) {
        
        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            var model = GJPBAccountBookModel()
            
            model.rest = "0"
            model.allIncome = "0"
            model.allSpending = "0"
            model.list = [GJPBAccountBookListModel]()
            
            for bill in fetchedObjects {
                if bill.type == 1 {
                    model.allIncome = model.allIncome?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    model.rest = model.rest?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                }else {
                    model.allSpending = model.allSpending?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    model.rest = model.rest?.subtrcing(num: bill.money ?? "0", eatEgg: .twoEgg)
                }
                
                let time = String(bill.time![bill.time!.startIndex...bill.time!.index(bill.time!.startIndex, offsetBy: 6)])
                
                var info: GJPBAccountBookListModel?
                
                for value in model.list! {
                    if value.time == time {
                        info = value
                        break
                    }
                }
                
                if info == nil {
                    info = GJPBAccountBookListModel()
                    info?.time = time
                    info?.income = "0"
                    info?.spending = "0"
                    model.list?.append(info!)
                }
                
                if bill.type == 1 {
                    info?.income = info?.income?.add(num: bill.money ?? "", eatEgg: .twoEgg)
                }else {
                    info?.spending = info?.spending?.add(num: bill.money ?? "", eatEgg: .twoEgg)
                }
            }
            
            success(model)
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    //获取月数据
    func getMonthRecord(date: String, success: @escaping (_ billModelArr: GJPBAccountBookModel) -> (), fail: @escaping () -> ()) {
        
        //查询
        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"time BEGINSWITH[cd] '\(date)'")  //设置查询条件按照id查找不设置查询条件，则默认全部查找
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            var model = GJPBAccountBookModel()
            
            model.rest = "0"
            model.allIncome = "0"
            model.allSpending = "0"
            model.list = [GJPBAccountBookListModel]()
            
            for bill in fetchedObjects {
                
                if bill.type == 1 {
                    model.allIncome = model.allIncome?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    model.rest = model.rest?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                }else {
                    model.allSpending = model.allSpending?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    model.rest = model.rest?.subtrcing(num: bill.money ?? "0", eatEgg: .twoEgg)
                }
                
                let time = bill.time!
                
                var info: GJPBAccountBookListModel?
                
                for value in model.list! {
                    if value.time == time {
                        info = value
                        break
                    }
                }
                
                if info == nil {
                    info = GJPBAccountBookListModel()
                    info?.time = time
                    info?.income = "0"
                    info?.spending = "0"
                    model.list?.append(info!)
                }
                
                if bill.type == 1 {
                    info?.income = info?.income?.add(num: bill.money!, eatEgg: .twoEgg)
                }else {
                    info?.spending = info?.spending?.add(num: bill.money!, eatEgg: .twoEgg)
                }
            }
            
            success(model)
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
}
