//
//  String+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/12.
//

import Foundation

// MARK: - 字符串常用
public extension String {
    
    /// 返回字符串长度
    /// 泰语和阿拉伯语下，使用String的count是不准确的
    /// 需要转换成NSString后，使用length
    var length: Int {
        return NSString(string: self).length
    }
    
    // 截取字符串
    func hktSubstring(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
