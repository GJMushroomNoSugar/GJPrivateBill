//
//  GJPBDataManager.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit
import CoreData

class GJPBDataManager: NSObject {
    static let share = GJPBDataManager()
    
    private override init() {}
    
    public lazy var myContext : NSManagedObjectContext! = {
        if #available(iOS 10.0, *) {
            return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        } else {
            return (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        }
    }()
    
    //初始化, 查询IncomeType,SpendingType为空, 存入默认数据
    func begin() {
        getIncomeTypeArr()
        getSpendingTypeArr()
    }
    
    var incomeTypeArr = [IncomeType]()
    
    var spendingTypeArr = [SpendingType]()
    
    func getIncomeTypeArr() {
        let incomeFetchRequest = NSFetchRequest<IncomeType>(entityName:"IncomeType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(incomeFetchRequest)
            
            if fetchedObjects.count == 0 {
                
                let arr = [("工资薪酬", "GJPBCurrency"), ("奖金福利", "GJPBPurse"), ("生意经营", "GJPBCalculator"), ("投资理财", "GJPBTrend"), ("彩票中奖", "GJPBDollar"), ("银行利息", "GJPBPiggyBank"), ("其他收入", "GJPBGoldCOINSAdd")]
                incomeTypeArr = [IncomeType]()
                //插入默认数据
                for i in 0..<arr.count {
                    let income = NSEntityDescription.insertNewObject(forEntityName: "IncomeType", into: myContext) as! IncomeType
                    
                    let (name, imageName) = arr[i]
                    
                    income.name = name
                    income.icon = imageName
                    
                    incomeTypeArr.append(income)
                    //保存
                    do {
                        try myContext.save()
                    } catch {
                        fatalError("不能保存：\(error)")
                    }
                }
                return
            }
            incomeTypeArr = fetchedObjects
            
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    func getSpendingTypeArr() {
        let spendingFetchRequest = NSFetchRequest<SpendingType>(entityName:"SpendingType")
        
        //查询操作
        do {
            let fetchedObjects = try myContext.fetch(spendingFetchRequest)
            
            if fetchedObjects.count == 0 {
                
                let arr = [("餐饮食品", "GJPBEat"), ("交通路费", "GJPBCar"), ("日常用品", "GJPBPackage"), ("学习教育", "GJPBDoctorialHat"), ("烟酒消费", "GJPBRedWine"), ("房租水电", "GJPBHouse"), ("网上购物", "GJPBGoldCOINSAdd"), ("运动健身", "GJPBTreadmill"), ("电子产品", "GJPBMobile"), ("化妆护理", "GJPBCosmetics"), ("医疗体验", "GJPBMedicineCabinet"), ("游戏娱乐", "GJPBConsole"), ("外出旅游", "GJPBPlane"), ("油费维护", "GJPBGasStation"), ("慈善捐赠", "GJPBIntegralCharity"), ("其他支出", "GJPBGoldCOINS")]
                spendingTypeArr = [SpendingType]()
                //插入默认数据
                for i in 0..<arr.count {
                    let spending = NSEntityDescription.insertNewObject(forEntityName: "SpendingType", into: myContext) as! SpendingType
                    
                    let (name, imageName) = arr[i]
                    
                    spending.name = name
                    spending.icon = imageName
                    
                    spendingTypeArr.append(spending)
                    //保存
                    do {
                        try myContext.save()
                    } catch {
                        fatalError("不能保存：\(error)")
                    }
                    
                }
                return
            }
            
            spendingTypeArr = fetchedObjects
        } catch {
            fatalError("不能查询：\(error)")
        }
    }
    
    func findIncomeIcon(name: String) -> String{
        
        for model in incomeTypeArr {
            if model.name == name {
                return model.icon!
            }
        }
        return ""
    }
    
    func findSpendingIcon(name: String) -> String {
        for model in spendingTypeArr {
            if model.name == name {
                return model.icon!
            }
        }
        return ""
    }
}
