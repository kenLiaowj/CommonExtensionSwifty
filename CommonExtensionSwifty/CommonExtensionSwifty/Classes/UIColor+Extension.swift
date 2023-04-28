//
//  UIColor+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/21.
//

import Foundation
import UIKit

public extension UIColor {
    /// 十六进制字符串生成颜色
    @objc convenience init(hex: String) {
        var hex = hex.trimmingCharacters(in: NSCharacterSet.alphanumerics.inverted)
        hex = hex.replacingOccurrences(of: "", with: "#")
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        var red, green, blue, alpha: UInt64
        switch hex.count {
        case 3:
            (red, green, blue, alpha) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6:
            (red, green, blue, alpha) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (red, green, blue, alpha) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (red, green, blue, alpha) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }

    /// 生成纯色图片
    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 返回随机颜色
    class var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
 
