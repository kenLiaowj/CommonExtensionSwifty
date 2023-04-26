//
//  Date+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/24.
//

import Foundation

/// 用于计算24节气的算法
import Foundation

fileprivate let x_1900_1_6_2_5 = 693966.08680556

fileprivate let vsolar_term_name = [ "小寒","大寒","立春","雨水",
                                     "惊蛰","春分","清明","谷雨",
                                     "立夏","小满","芒种","夏至",
                                     "小暑","大暑","立秋","处暑",
                                     "白露","秋分","寒露","霜降",
                                     "立冬","小雪","大雪","冬至"]

fileprivate let termInfo = [ 0.0   , 21208 , 42467 , 63836 , 85337 , 107014,
                             128867, 150921, 173149, 195551, 218072, 240693,
                             263343, 285989, 308563, 331033, 353350, 375494,
                             397447, 419210, 440795, 462224, 483532, 504758 ]

extension Date {
    
    /// 年
    var year: Int {
        return Calendar.gregorian.dateComponents([.year], from: self).year ?? 0
    }
    
    /// 月
    var month: Int {
        return Calendar.gregorian.dateComponents([.month], from: self).month ?? 0
    }
    
    /// 日
    var day: Int {
        return Calendar.gregorian.dateComponents([.day], from: self).day ?? 0
    }
    
    /// 时
    var hour: Int {
        return Calendar.gregorian.dateComponents([.hour], from: self).hour ?? 0
    }
    
    /// 分
    var minute: Int {
        return Calendar.gregorian.dateComponents([.minute], from: self).minute ?? 0
    }
    
    /// 秒
    var second: Int {
        return Calendar.gregorian.dateComponents([.year], from: self).second ?? 0
    }
    
    /// 1970年以来的秒数
    var seconds: Int {
        return Int(self.timeIntervalSince1970)
    }
    
    /// 1970年以来的毫秒数
    var milliSeconds: Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
    
    /// 是否是周末
    var isWeekend: Bool {
        return Calendar.gregorian.isDateInWeekend(self)
    }
    
    /// 天数差
    func dayDiff(to date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startDate = dateFormatter.date(from: self.formatString("yyyy-MM-dd"))!
        let endDate = dateFormatter.date(from: date.formatString("yyyy-MM-dd"))!

        return Calendar.gregorian.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
    
    /// 是否是同一天
    func isSameDay(with date: Date) -> Bool {
        return dayDiff(to: date) == 0
    }
    
    /// 日期格式化
    func formatString(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 获取指定日期对应的节气
    static func fetchSolarTerm(date: Date) -> String {
        if let year = Int(date.formatString("yyyy")) {
            let solarDic = solarTerms(for: year)
            return solarDic[date.formatString(("yyyy-MM-dd"))] ?? ""
        }
        return ""
    }
    
    /// 获取对应年份的的机器
    static func solarTerms(for year: Int) -> [String : String] {
        var solarDic = [String : String]()
        // 24节气
        (0..<24).forEach { (i) in
            let solarTerm = x_1900_1_6_2_5 + 365.2422 * (Double(year) - 1900) + termInfo[i] / (60 * 24)
            let dateStr = format_date(c: Int(solarTerm))
            solarDic[dateStr] = vsolar_term_name[i]
        }
        return solarDic
    }
    
    private static func format_date(c: Int) -> String {
        let mdays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365]
        var y , m , d , diff: Int
        var days = 100 * (c - c / (3652425 / (3652425-3652400)))
        y = days / 36524
        days %= 36524
        m = 1 + days / 3044            /* [1..12] */
        d = 1 + (days % 3044) / 100    /* [1..31] */
        diff = y * 365 + y / 4 - y / 100 + y / 400 + mdays[m - 1] + d - (((m <= 2 && ((y & 3) == 0) && ((y % 100) != 0 || (y % 400) == 0))) ? 1 : 0) - c
        if( diff > 0 && diff >= d ) {   /* ~0.5% */
            if m == 1 {
                y -= 1
                m = 12
                d = 31 - ( diff - d )
                
            } else {
                d = mdays[m - 1] - ( diff - d )
                m -= 1
                if m == 2 {
                    d += (((y & 3) == 0) && ((y % 100) != 0 || y % 400 == 0)) ? 1 : 0
                }
            }
            
        } else {
            d -= diff
            if d > mdays[m] {   /* ~1.6% */
                if( m == 2 ) {
                    if(((y & 3) == 0) && ((y % 100) != 0 || y % 400 == 0)) {
                        if( d != 29 ) {
                            m = 3
                            d -= 29
                        }
                        
                    } else {
                        m = 3
                        d -= 28
                    }
                    
                } else {
                    d -= mdays[m]
                    m += 1
                    if( m - 1 == 12 ) {
                        y += 1
                        m = 1
                    }
                }
            }
        }
        return String(format: "%04d-%02d-%02d", y , m , d)
    }
}
