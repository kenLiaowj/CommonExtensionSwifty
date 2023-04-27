//
//  TestResourceView.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/27.
//

import UIKit
import SnapKit

public class TestResourceView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImageView(image: BundleHelper.image(name: "chat_input_likeEmog"))
        self.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
