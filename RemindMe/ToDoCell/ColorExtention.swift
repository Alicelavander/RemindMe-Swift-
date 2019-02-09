//
//  ColorExtention.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/09.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit

extension UIColor {
    public static var red = "fb6542"
    public static var blue = "375e97"
    public static var yellow = "ffbb00"
    public static var green = "3f681c"
    
    convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
