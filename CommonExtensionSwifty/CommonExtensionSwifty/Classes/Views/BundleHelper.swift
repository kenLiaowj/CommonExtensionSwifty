//
//  BundleHelper.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/27.
//

import Foundation
import UIKit

private class BundleHelperClass {}
struct BundleHelper {
    static var bundle = Bundle(for: BundleHelperClass.self)
}

extension BundleHelper {
    static func image(name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}
