//
//  String+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/12.
//

import Foundation
import UIKit
import CommonCrypto

// MARK: - 字符串常用
public extension String {
    
    /// UTF-16编码长度
    var length: Int {
        return self.utf16.count
    }
    
    /// 截取字符串
    func substring(to index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    
    /// 字符串生成二维码图片
    func generateQRCode(forgroundColor: UIColor = .black, backgroundColor: UIColor = .white) -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                // 将二维码颜色替换为红色
                let filter = CIFilter(name: "CIFalseColor")!
                filter.setValue(output, forKey: "inputImage")
                filter.setValue(CIColor(color: forgroundColor), forKey: "inputColor0")
                filter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
                
                // 获取新的 CIImage 对象
                let ciImage = filter.outputImage
                
                // 将 CIImage 对象转换为 UIImage 对象
                return UIImage(ciImage: ciImage!)
            }
        }
        
        return nil
    }
    
    /// 邮箱匹配
    func verifyEmail() -> Bool {
        let emailVerifyString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", emailVerifyString)
        return predicate.evaluate(with: self)
    }
    
    /// 手机号匹配
    /// 默认校验大陆手机号
    func verifyPhone(formatter: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$") -> Bool {
        let phoneVerifyString = formatter
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", phoneVerifyString)
        return predicate.evaluate(with: self)
    }
    
    /// 密码判断：数字、字母、符号至少两种，且8-20位
    func verifyPassword() -> Bool {
        let passwordVerifyString = "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{8,20}$"
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", passwordVerifyString)
        return predicate.evaluate(with: self)
    }
    
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .whitespaces)
    }
    
    /// 去除前后空格换行 中间多个空格和换行变成一个
    public func stringWhitespacesAndLines() -> String{
        var resultString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        while resultString.contains("  ") {
            resultString = resultString.replacingOccurrences(of: "  ", with: " ")
        }
        while resultString.contains("\n ") {
            resultString = resultString.replacingOccurrences(of: "\n ", with: "\n")
        }
        while resultString.contains("\n\n") {
            resultString = resultString.replacingOccurrences(of: "\n\n", with: "\n")
        }
        return resultString
    }
    
    /// MD5
    var md5: String {
        let str = cString(using: .utf8)
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        var hash = ""
        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deallocate()
        return hash.uppercased()
    }
}

// MARK: - 颜色相关
extension String {
    /// 十六进制字符串生成颜色
    public var color: UIColor {
        if self.isEmpty {
            return UIColor.clear
        }
        return UIColor(hex: self)
    }
    
    /// CGColor
    public var cgColor: CGColor { return color.cgColor }
}
