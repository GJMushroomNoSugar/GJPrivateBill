//
//  GJBPImage.swift
//  GJ Private Bill
//
//  Created by gj on 2018/10/15.
//  Copyright © 2018年 GJMoGuNoSugar. All rights reserved.
//

import UIKit

enum GradientType {
    case topToBottom
    case leftToRight
    case upleftToLowright
    case uprightToLowleft
}

extension UIImage {
    
    /**
     *   纯色方形图片
     */
    func image(withColor color: UIColor, size: CGSize) -> UIImage? {
        
        return image(withColor: color, size: size, roundSize: 0)
    }
    
    /**
     *   纯色图片(切圆角)
     */
    func image(withColor color: UIColor, size: CGSize, roundSize: Float) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let context = UIGraphicsGetCurrentContext()
        if roundSize > 0 {
            let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(roundSize))
            color.setFill()
            bezierPath.fill()
        }else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /**
     *   渐变色图片
     */
    func image(withColors colors: [UIColor], size: CGSize, gradientType: GradientType) -> UIImage? {
        
        var colorArr = [CGColor]()
        for color in colors {
            colorArr.append(color.cgColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        let colorSpace = colorArr.last?.colorSpace
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colorArr as CFArray, locations: nil) else {
            return UIImage()
        }
        
        var start: CGPoint
        var end: CGPoint
        
        switch gradientType {
        case .topToBottom:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: 0, y: size.height)
        case .leftToRight:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: size.width, y: 0)
        case .upleftToLowright:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: size.width, y: size.height)
        case .uprightToLowleft:
            start = CGPoint(x: size.width, y: 0)
            end = CGPoint(x: 0, y: size.height)
        }
        
        context?.drawLinearGradient(gradient, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
