//
//  TestResourceView.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/27.
//

import UIKit

class TestResourceView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImageView(image: UIImage(named: "chat_input_likeEmog"))
        self.addSubview(image)
        image.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
