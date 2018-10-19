//
//  GJPBDataManager+Statistical.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/18.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//
import CoreData

extension GJPBDataManager {
    //本月支出收入
    func getMonthPercentage(date: String, success: @escaping (_ billModelArr: GJPBStatisticsModel) -> (), fail: @escaping () -> ()) {
        
        //查询
        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"time BEGINSWITH[cd] '\(date)'")  //设置查询条件按照id查找不设置查询条件，则默认全部查找
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            var model = GJPBStatisticsModel()
            
            model.allIncome = "0"
            model.allSpending = "0"
            model.incomeList = [GJPBStatisticsListModel]()
            model.spendingList = [GJPBStatisticsListModel]()
            
            for bill in fetchedObjects {
                
                var info: GJPBStatisticsListModel?
                
                if bill.type == 1 {
                    model.allIncome = model.allIncome?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    for value in model.incomeList! {
                        if value.name == bill.typeName {
                            info = value
                            break
                        }
                    }
                    
                    if info == nil {
                        info = GJPBStatisticsListModel()
                        info?.name = bill.typeName
                        info?.money = "0"
                        model.incomeList?.append(info!)
                    }
                }else {
                    model.allSpending = model.allSpending?.add(num: bill.money ?? "0", eatEgg: .twoEgg)
                    for value in model.spendingList! {
                        if value.name == bill.typeName {
                            info = value
                            break
                        }
                    }
                    
                    if info == nil {
                        info = GJPBStatisticsListModel()
                        info?.name = bill.typeName
                        info?.money = "0"
                        model.spendingList?.append(info!)
                    }
                }
                
                info?.money = info?.money?.add(num: bill.money!, eatEgg: .twoEgg)
            }
            
            for info in model.incomeList! {
                info.percentage = Float(info.money?.dividingBy(num: model.allIncome!, eatEgg: .otherEgg(index: 3)) ?? "")
            }
            
            for info in model.spendingList! {
                info.percentage = Float(info.money?.dividingBy(num: model.allSpending!, eatEgg: .otherEgg(index: 3)) ?? "")
            }
            
            success(model)
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    //查询当月所有一个数据
    func getTongjiDetail(date: String, type: Int16, name: String, success: @escaping (_ billModelArr: GJPBAccountBookModel) -> (), fail: @escaping () -> ()) {
        
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
                
                if bill.typeName != name {
                    continue
                }
                
                if bill.type != type {
                    continue
                }
                
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
    
    //查询某一天某项数据
    func requestInfo(date: String, type: Int16, name: String, success: @escaping (_ billModelArr: [Bill]) -> ()) {
        //查询
        let spendingFetchRequest = NSFetchRequest<Bill>(entityName:"Bill")
        
        let predicate = NSPredicate(format:"time == '\(date)'")  //设置查询条件按照id查找不设置查询条件，则默认全部查找
        
        spendingFetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            var arr = [Bill]()
            
            for info in fetchedObjects {
                if info.typeName == name && info.type == type {
                    arr.append(info)
                }
            }
            success(arr)
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
}
