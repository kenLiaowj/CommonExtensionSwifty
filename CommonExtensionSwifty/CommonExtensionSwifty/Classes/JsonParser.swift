//
//  JsonParser.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/21.
//

import Foundation

import Foundation

enum JSONParseError: Error {
    case invalidData
    case missingValue(key: String)
    case typeMismatch(key: String)
}

class JSONParser {
    /// 解析json字符串成对象
    static func parseObject<T: Decodable>(_ json: String, type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> (T?, JSONParseError?) {
        guard let data = json.data(using: .utf8) else {
            return (nil, JSONParseError.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyDecodingStrategy
            let object = try decoder.decode(type, from: data)
            return (object, nil)
            
        } catch {
            return (nil, JSONParseError.invalidData)
        }
    }
    
    /// 解析json字符串成数组
    static func parseArray<T: Decodable>(_ json: String, type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> ([T], JSONParseError?) {
        guard let data = json.data(using: .utf8) else {
            return ([], JSONParseError.invalidData)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyDecodingStrategy
            let array = try decoder.decode([T].self, from: data)
            return (array, nil)
        } catch {
            return ([], JSONParseError.invalidData)
        }
    }
    
    /// 解析json字符串成字典
    static func parseDictionary(_ json: String) -> ([String: Any], JSONParseError?)  {
        guard let data = json.data(using: .utf8) else {
            return ([:], JSONParseError.invalidData)
        }
        do {
            let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
            return (dic, nil)
        } catch {
            return ([:], JSONParseError.invalidData)
        }
    }
    
    /// 解析json字符串中指定key成对象
    static func parseObject<T: Decodable>(_ json: String, type: T.Type, key: String) -> (T?, JSONParseError?) {
        do {
            if let data = json.data(using: .utf8),
               let dict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any>,
               let jsonDic = dict[key] as? Dictionary<String,Any> {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDic)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return Self.parseObject(jsonString, type: type)
                    
                } else {
                    return (nil, JSONParseError.invalidData)
                }
                
            } else {
                return (nil, JSONParseError.invalidData)
            }
            
        } catch {
            return (nil, JSONParseError.invalidData)
        }
    }
}
