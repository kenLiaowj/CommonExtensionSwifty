//
//  ViewController.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/12.
//

import UIKit
import Foundation

struct MatchingOptions: OptionSet {
    let rawValue: UInt
    
    static let strict = MatchingOptions(rawValue: 1 << 0)
    static let nextTime = MatchingOptions(rawValue: 1 << 1)
    static let nearest = MatchingOptions(rawValue: 1 << 2)
}


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let uuid = KeyChainStorage.getDeviceID {
            return UUID().uuidString
        }
        
        print("---\(uuid)")
        
        let personJson = #"[{"userId": 1,"id": 1,"aa": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit","body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"},{"userId": 2,"id": 2,"title": "qui est esse","body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"}]"#
        
        let (persons, _) = JSONParser.parseArray(personJson, type: Person.self)
        print(persons.first?.dictionary)
        
        let view = TestResourceView()
        self.view.addSubview(view)
        view.frame = CGRect(x: 100, y: 100, width: 24, height: 24)
    }
}

protocol WMDetachable { }
extension WMDetachable {
    var dictionary: [String : Any] { return toDictionary() }
    private func toDictionary() -> [String : Any] {
        let mirror = Mirror(reflecting: self)
        guard mirror.children.count > 0 else { return [:] }
        
        var dict = [String : Any]()
        for case let (label?, value)  in mirror.children {
            if let detachable = value as? (WMDetachable) {
                dict[label] = detachable.dictionary
            }
            dict[label] = value
        }
        return dict
    }
}

struct Person: Codable, WMDetachable {
    @DecodableDefault.Zero var userId: Int
    @DecodableDefault.Zero var id: Int
    @DecodableDefault.EmptyString var title: String
    @DecodableDefault.EmptyString var body: String
}

struct Teacher: Codable {
    @DecodableDefault.EmptyString var name: String
}

struct Student: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
