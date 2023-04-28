//
//  UIImage+Extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/21.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 识别图片中的二维码
    func detectorQRCode() -> String {
        guard let ciImage = CIImage(image: self) else {
            return ""
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        
        let features = detector?.features(in: ciImage)
        if let feature = features?.first as? CIQRCodeFeature {
            return feature.messageString ?? ""
        }
        return ""
    }
    
    /// 图片base64编码
    public func base64(maxFileSize: Int = 1024 * 1024) -> String? {
        var compression: CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        
        while data.count > maxFileSize {
            compression -= 0.1
            guard compression >= 0 else {
                return nil
            }
            if let jpegData = self.jpegData(compressionQuality: compression) {
                data = jpegData
            } else {
                return nil
            }
        }
        return data.base64EncodedString()
    }
    
    // 图片镜像翻转
    public func flipped(scale: CGFloat? = nil) -> UIImage {
        if let cgImage = self.cgImage {
            // 创建矩形框
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            // 创建基于位图的图形上下文
            UIGraphicsBeginImageContextWithOptions(rect.size, false, scale ?? self.scale)
            // 获取当前绘图环境
            let currentContext = UIGraphicsGetCurrentContext()!
            // 设置当前绘图环境到矩形框
            currentContext.clip(to: rect)
            // 旋转180度
            currentContext.rotate(by: CGFloat.pi)
            // 平移
            currentContext.translateBy(x: -rect.size.width, y: -rect.size.height)
            // 绘图
            currentContext.draw(cgImage, in: rect)
            // 获得图片
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            if let cgDrawImage = drawImage?.cgImage {
                let flipImage = UIImage(cgImage: cgDrawImage, scale: scale ?? self.scale, orientation: self.imageOrientation)
                return flipImage
            }
        }
        return self
    }
}
