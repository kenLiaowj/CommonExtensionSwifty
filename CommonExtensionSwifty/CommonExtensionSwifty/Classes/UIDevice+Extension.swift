//
//  UIDevice+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/21.
//

import UIKit

public extension UIDevice {
    
    /// 获取设备id
    static func device_id(deviceIDHandler: (() -> String)? = { UUID().uuidString }) -> String {
        return KeyChainStorage.getDeviceID(deviceIDHandler: deviceIDHandler)
    }
}
