//
//  UIView+extension.swift
//  CommonExtensionSwifty
//
//  Created by liaoweijian on 2023/4/24.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    
    // MARK: - IBInspectable
    /// 圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// 边框宽度
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0
        }
    }
    
    /// 边框颜色
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// 阴影圆角半径
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// 阴影透明度
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// 阴影颜色
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor.init(cgColor: layer.shadowColor!) : nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// 阴影偏移
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
}

// MARK: - Corner
extension UIView {
    
    /// 上圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角半径
    @objc func topCorner(radii: CGFloat) {
        corner(byRoundingCorners: [.topLeft, .topRight], radii: radii)
    }
    
    /// 下圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角半径
    @objc func bottomCorner(radii: CGFloat) {
        corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: radii)
    }
    
    /// 左圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角半径
    @objc func leftCorner(radii: CGFloat) {
        corner(byRoundingCorners: [.bottomLeft, .topLeft], radii: radii)
    }
    
    /// 右圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角半径
    @objc func rightCorner(radii: CGFloat) {
        corner(byRoundingCorners: [.bottomRight, .topRight], radii: radii)
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    @objc func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        if radii > 0 {
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radii, height: radii))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = CGRect(x: self.bounds.origin.x,
                                     y: self.bounds.origin.y,
                                     width: self.bounds.size.width,
                                     height: self.bounds.size.height)
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }else {
            self.layer.mask = nil
        }
    }
    
    /**
     依照图片轮廓对控制进行裁剪
     
     - parameter stretchImage:  模子图片
     - parameter stretchInsets: 模子图片的拉伸区域
     */
    func clipShape(stretchImage: UIImage, stretchInsets: UIEdgeInsets) {
        // 绘制 imageView 的 bubble layer
        let bubbleMaskImage = stretchImage.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        
        // 设置图片的mask layer
        let layer = CALayer()
        layer.contents = bubbleMaskImage.cgImage
        layer.contentsCenter = self.CGRectCenterRectForResizableImage(bubbleMaskImage)
        layer.frame = self.bounds
        layer.contentsScale = UIScreen.main.scale
        layer.opacity = 1
        self.layer.mask = layer
        self.layer.masksToBounds = true
    }
    
    func CGRectCenterRectForResizableImage(_ image: UIImage) -> CGRect {
        return CGRect(
            x: image.capInsets.left / image.size.width,
            y: image.capInsets.top / image.size.height,
            width: (image.size.width - image.capInsets.right - image.capInsets.left) / image.size.width,
            height: (image.size.height - image.capInsets.bottom - image.capInsets.top) / image.size.height
        )
    }
}

extension UIView {
    /// view 所属控制器
    var viewController: UIViewController? {
        var next:UIView? = self
        repeat {
            if let nextResponder = next?.next, nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        } while next != nil
        
        return nil
    }
    
    /// 批量添加子控件
    func addSubviews(views: [UIView]) {
        views.forEach {addSubview($0) }
    }
    
    /// 获取View的屏幕快照
    @objc func screenShot() -> UIImage? {
        guard frame.size != .zero else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
