//
//  GJPBString.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import Foundation

//保留小数位数(四舍五入)
enum eatEgg {
    case zeroEgg
    case oneEgg
    case twoEgg
    case otherEgg(index: Int16)
    
    var handler: NSDecimalNumberHandler {
        var scale: Int16
        switch self {
        case .zeroEgg:
            scale = 0
        case .oneEgg:
            scale = 1
        case .twoEgg:
            scale = 2
        case .otherEgg(let index):
            scale = index
        }
        return NSDecimalNumberHandler.init(roundingMode: .bankers, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        
    }
}

// MARK: - Helpers
extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}

//MARK: - 计算器
extension String {
    
    // 判断是否是整型或浮点型
    func isPurnInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var intVal:Int = 0
        if scan.scanInt(&intVal) && scan.isAtEnd {//是整型
            return true
        }
        
        var floatVal: Float = 0.0
        return scan.scanFloat(&floatVal) && scan.isAtEnd
    }
    
    //加
    func add(num: String, eatEgg egg: eatEgg?) -> String {
        
        var numOne = self
        var numTwo = num
        
        if !numOne.isPurnInt() {
            numOne = "0"
        }
        
        if !numTwo.isPurnInt() {
            numTwo = "0"
        }
        
        let oneDecimalNum = NSDecimalNumber(string: numOne)
        let twoDecimalNum = NSDecimalNumber(string: numTwo)
        
        if let newEgg = egg {
            return oneDecimalNum.adding(twoDecimalNum, withBehavior: newEgg.handler).stringValue
        }
        
        return oneDecimalNum.adding(twoDecimalNum).stringValue
    }
    
    //减
    func subtrcing(num: String, eatEgg egg: eatEgg?) -> String {
        var numOne = self
        var numTwo = num
        
        if !numOne.isPurnInt() {
            numOne = "0"
        }
        
        if !numTwo.isPurnInt() {
            numTwo = "0"
        }
        
        let oneDecimalNum = NSDecimalNumber(string: numOne)
        let twoDecimalNum = NSDecimalNumber(string: numTwo)
        
        if let newEgg = egg {
            return oneDecimalNum.subtracting(twoDecimalNum, withBehavior: newEgg.handler).stringValue
        }
        
        return oneDecimalNum.subtracting(twoDecimalNum).stringValue
        
    }
    
    //乘
    func multiplyingby(num: String, eatEgg egg: eatEgg?) -> String {
        var numOne = self
        var numTwo = num
        
        if !numOne.isPurnInt() {
            numOne = "0"
        }
        
        if !numTwo.isPurnInt() {
            numTwo = "0"
        }
        
        let oneDecimalNum = NSDecimalNumber(string: numOne)
        let twoDecimalNum = NSDecimalNumber(string: numTwo)
        
        if let newEgg = egg {
            return oneDecimalNum.multiplying(by: twoDecimalNum, withBehavior: newEgg.handler).stringValue
        }
        
        return oneDecimalNum.multiplying(by: twoDecimalNum).stringValue
    }
    
    //除
    func dividingBy(num: String, eatEgg egg: eatEgg?) -> String {
        var numOne = self
        var numTwo = num
        
        if !numOne.isPurnInt() {
            numOne = "0"
        }
        
        if !numTwo.isPurnInt() {
            numTwo = "1"
        }
        
        let oneDecimalNum = NSDecimalNumber(string: numOne)
        let twoDecimalNum = NSDecimalNumber(string: numTwo)
        
        if let newEgg = egg {
            return oneDecimalNum.dividing(by: twoDecimalNum, withBehavior: newEgg.handler).stringValue
        }
        
        return oneDecimalNum.dividing(by: twoDecimalNum).stringValue
    }
    
    //金额处理
    func moneyDeal() -> String {
        
        guard let money = Double(self) else {
            return self
        }
        
        if money >= 10000000 {
            return "\(self.dividingBy(num: "10000000", eatEgg: .otherEgg(index: 9)))千万"
        }
        
        if money >= 10000 {
            return "\(self.dividingBy(num: "10000", eatEgg: .otherEgg(index: 6)))万"
        }
        
        return "\(self.dividingBy(num: "1", eatEgg: .twoEgg))"
    }
    
}
