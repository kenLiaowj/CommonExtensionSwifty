//
//  ViewController.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let uuid = KeyChainStorage.getDeviceID {
            return UUID().uuidString
        }
        
        print("---\(uuid)")
        
        
        let image = UIImageView()
        image.image = "#FF00FF".color.image()//uuid.generateQRCode(forgroundColor: .blue, backgroundColor: .red)
        self.view.addSubview(image)
        
        image.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        let personJson = #"[{"userId": 1,"id": 1,"aa": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit","body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"},{"userId": 2,"id": 2,"title": "qui est esse","body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"}]"#
        
        let (persons, _) = JSONParser.parseArray(personJson, type: Person.self)
        print(persons)
    }
}

struct Person: Codable {
    @DecodableDefault.Zero var userId: Int
    @DecodableDefault.Zero var id: Int
    @DecodableDefault.EmptyString var title: String
    @DecodableDefault.EmptyString var body: String
}

struct Teacher: Codable {
    @DecodableDefault.EmptyString var name: String
}
