//
//  GJPBDataManager+Mine.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import CoreData

extension GJPBDataManager {
    
    //添加类别
    func addType(name: String, type: Int16, icon: String, success: @escaping () -> (), fail: @escaping () -> ()) {
        
        if type == 1 {
            let income = NSEntityDescription.insertNewObject(forEntityName: "IncomeType", into: myContext) as! IncomeType
            
            income.name = name
            income.icon = icon
            
            //保存
            do {
                try myContext.save()
                success()
            } catch {
                fail()
                fatalError("不能保存：\(error)")
            }
            return
        }
        let spending = NSEntityDescription.insertNewObject(forEntityName: "SpendingType", into: myContext) as! SpendingType
        
        spending.name = name
        spending.icon = icon
        
        //保存
        do {
            try myContext.save()
            success()
        } catch {
            fail()
            fatalError("不能保存：\(error)")
        }
    }
    
    //类型重命名
    func resetType(type: Int16, name: String, newName: String, success: @escaping () -> (), fail: @escaping () -> ()) {
        if type == 1 {
            //查询
            let spendingFetchRequest = NSFetchRequest<IncomeType>(entityName:"IncomeType")
            
            //查询操作
            do {
                let fetchedObjects = try myContext.fetch(spendingFetchRequest)
                
                for info in fetchedObjects {
                    info.name = newName
                    try myContext.save()
                }
                
                getIncomeTypeArr()
                
                success()
            } catch {
                fail()
                fatalError("不能查询：\(error)")
            }
            return
        }
        
        //查询
        let spendingFetchRequest = NSFetchRequest<SpendingType>(entityName:"SpendingType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            for info in fetchedObjects {
                info.name = newName
                try myContext.save()
            }
            
            getSpendingTypeArr()
            success()
        } catch {
            fail()
            fatalError("不能查询：\(error)")
        }
    }
    
    func deleteType(type: Int16, name: String) {
        if type == 1 {
            //查询
            let spendingFetchRequest = NSFetchRequest<IncomeType>(entityName:"IncomeType")
            
            //查询操作
            do {
                let fetchedObjects = try myContext.fetch(spendingFetchRequest)
                
                for info in fetchedObjects {
                    myContext.delete(info)
                }
                
            } catch {
                
                fatalError("不能查询：\(error)")
            }
            return
        }
        
        //查询
        let spendingFetchRequest = NSFetchRequest<SpendingType>(entityName:"SpendingType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            for info in fetchedObjects {
                myContext.delete(info)
            }
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    func exchangeType(type: Int16, row: Int, newRow: Int) {
        if type == 1 {
            //查询
            let spendingFetchRequest = NSFetchRequest<IncomeType>(entityName:"IncomeType")
            
            //查询操作
            do {
                let fetchedObjects = try myContext.fetch(spendingFetchRequest)
                
                let name = fetchedObjects[row].name
                let icon = fetchedObjects[row].icon
                
                fetchedObjects[row].name = fetchedObjects[newRow].name
                fetchedObjects[row].icon = fetchedObjects[newRow].icon
                
                fetchedObjects[newRow].name = name
                fetchedObjects[newRow].icon = icon
                try myContext.save()
            } catch {
                fatalError("不能查询：\(error)")
            }
            return
        }
        
        //查询
        let spendingFetchRequest = NSFetchRequest<SpendingType>(entityName:"SpendingType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            let name = fetchedObjects[row].name
            let icon = fetchedObjects[row].icon
            
            fetchedObjects[row].name = fetchedObjects[newRow].name
            fetchedObjects[row].icon = fetchedObjects[newRow].icon
            
            fetchedObjects[newRow].name = name
            fetchedObjects[newRow].icon = icon
            try myContext.save()
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    func clearData(success: () -> ()) {
        //查询
        let billFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        let spendingFetchRequest = NSFetchRequest<SpendingType>(entityName:"SpendingType")
        let incomeFetchRequest = NSFetchRequest<IncomeType>(entityName:"IncomeType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(billFetchRequest)
            
            for info in fetchedObjects {
                myContext.delete(info)
            }
            
            let spendingFetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            for info in spendingFetchedObjects {
                myContext.delete(info)
            }
            
            let incomeFetchedObjects = try myContext.fetch(incomeFetchRequest)
            
            for info in incomeFetchedObjects {
                myContext.delete(info)
            }
            begin()
            NotificationCenter.default.post(name: NSNotification.Name(GJPBUPDATENOTIFICATION), object: nil)
            success()
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
}
