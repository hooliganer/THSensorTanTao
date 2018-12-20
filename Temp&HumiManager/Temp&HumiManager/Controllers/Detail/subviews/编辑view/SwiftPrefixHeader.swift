//
//  SwiftPrefixHeader.swift
//  TestSwift
//
//  Created by terry on 2018/3/12.
//  Copyright © 2018年 terry. All rights reserved.
//

import UIKit

let MainScreenWidth = UIScreen.main.bounds.size.width
let MainScreenHeight = UIScreen.main.bounds.size.height

//带透明度的随机颜色
func RandomColor(alpha:CGFloat) -> UIColor {
    return UIColor.init(red: CGFloat(arc4random_uniform(256))/CGFloat(255.0), green: CGFloat(arc4random_uniform(256))/CGFloat(255.0), blue: CGFloat(arc4random_uniform(256))/CGFloat(255.0), alpha: alpha)
}

//随机颜色
func RandomColor() -> UIColor {
    return UIColor.init(red: CGFloat(arc4random_uniform(256))/CGFloat(255.0), green: CGFloat(arc4random_uniform(256))/CGFloat(255.0), blue: CGFloat(arc4random_uniform(256))/CGFloat(255.0), alpha: 1)
}

//横向数值 适配
func Fit_X(value:CGFloat) -> CGFloat {
    return (value/414.0)*MainScreenWidth
}

//纵向数值 适配
func Fit_Y(value:CGFloat) -> CGFloat {
    return (value/414.0)*MainScreenHeight
}
