//
//  Calendar+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/24.
//

import Foundation

public extension Calendar {
    
    /// 公历
    static var gregorian: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.current
        calendar.timeZone = TimeZone.current
        return calendar
    }
    
    /// 农历
    static var chineseCalendar: Calendar {
        var calendar = Calendar(identifier: .chinese)
        calendar.locale = Locale(identifier: "zh_CH")
        return calendar
    }
}
