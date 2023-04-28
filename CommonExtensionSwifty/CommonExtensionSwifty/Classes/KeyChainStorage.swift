//
//  KeyChainStorage.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/21.
//

import Foundation

public class KeyChainStorage: NSObject {
    
    /// device_id存储key
    static let DEVICE_ID_STORAGE_KEY = "DEVICE_ID_STORAGE_KEY"
    
    // MARK: 创建查询条件
    public class func createQuaryMutableDictionary(identifier:String) -> NSMutableDictionary {
        // 创建一个条件字典
        let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置条件存储的类型
        keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        // 设置存储数据的标记
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
        keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
        // 设置数据访问属性
        keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        // 返回创建条件字典
        return keychainQuaryMutableDictionary
    }
    
    // MARK: 存储数据
    public class func keyChainSaveData(data:Any ,withIdentifier identifier:String) -> Bool {
        // 获取存储数据的条件
        let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除旧的存储数据
        SecItemDelete(keyChainSaveMutableDictionary)
        // 设置数据
        keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 进行存储数据
        let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
        if saveState == noErr  {
            return true
        }
        return false
    }
    
    // MARK: 更新数据
    public class func keyChainUpdata(data:Any ,withIdentifier identifier:String) -> Bool {
        // 获取更新的条件
        let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 创建数据存储字典
        let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
        // 设置数据
        updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
        // 更新数据
        let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
        if updataStatus == noErr {
            return true
        }
        return false
    }
    
    // MARK: 获取数据
    public class func keyChainReadData(identifier:String) -> Any {
        var idObject:Any?
        // 获取查询条件
        let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 提供查询数据的两个必要参数
        keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
        // 创建获取数据的引用
        var queryResult: AnyObject?
        // 通过查询是否存储在数据
        let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
        if readStatus == errSecSuccess {
            if let data = queryResult as! NSData? {
                idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
            }
        }
        return idObject as Any
    }
    
    // MARK: 删除数据
    public class func keyChainDelete(identifier:String) -> Void {
        // 获取删除的条件
        let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
        // 删除数据
        SecItemDelete(keyChainDeleteMutableDictionary)
    }
    
    // MARK: 获取设备id
    public class func getDeviceID(deviceIDHandler: (() -> String)?) -> String {
        if let deviceID = UserDefaults.standard.value(forKey: DEVICE_ID_STORAGE_KEY) as? String {
            return deviceID
        }
        if let deviceID = Self.keyChainReadData(identifier: DEVICE_ID_STORAGE_KEY) as? String {
            return deviceID
        }
        // 生成device_id
        let device_id = deviceIDHandler?() ?? UUID().uuidString
        // 存储到沙箱
        UserDefaults.standard.setValue(device_id, forKey: DEVICE_ID_STORAGE_KEY)
        UserDefaults.standard.synchronize()
        // 存储到keychain
        let succ = Self.keyChainSaveData(data: device_id, withIdentifier: DEVICE_ID_STORAGE_KEY)
        print(succ ? "存储\(device_id)成功🚀" : "存储\(device_id)失败☹️")
        
        return device_id
    }
}
