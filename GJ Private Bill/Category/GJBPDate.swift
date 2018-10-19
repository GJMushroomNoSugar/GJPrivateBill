//
//  GJBPDate.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import Foundation

extension Date {
    
    /// date -> string
    ///
    /// - Parameters:
    ///   - date: date
    ///   - dateFormatter: dateFormatter string
    /// - Returns: date string
    static func string(date: Date, dateFormatter: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date)
    }
    
    
    /// string -> date
    ///
    /// - Parameters:
    ///   - date: date string
    ///   - dateFormatter: dateformatter string
    /// - Returns: date
    static func date(date: String, dateFormatter: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.date(from: date)
    }
}
