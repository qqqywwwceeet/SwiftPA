//
//  PAView.swift
//  SwiftPA
//
//  Created by 彭天明 on 2023/12/14.
//

import UIKit

extension UIView: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == UIView {
    
    var relateViewController: UIViewController? {
        for view in sequence(first: base.superview, next: { $0?.superview} ) {
            if let responder = view?.next{
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    func renderImage() -> UIImage? {
        return UIImage.pa.fromLayer(layer: base.layer)
    }
    
    func removeSubviews() {
        base.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func addTransition(duration: Double = 0.25, type: CATransitionType = .fade, timingFunction: CAMediaTimingFunctionName = .easeInEaseOut) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = type
        transition.timingFunction = CAMediaTimingFunction(name: timingFunction)
        base.layer.add(transition, forKey: "transition")
    }
    
    func addInnerShadow(shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        base.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        
        let innerShadow = CALayer()
        innerShadow.frame = base.bounds
        
        // Shadow path (1pt ring around bounds)
        let radius = base.layer.cornerRadius
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: 2, dy:2), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        
        // Shadow properties
        innerShadow.shadowColor = shadowColor.cgColor
        innerShadow.shadowOffset = shadowOffset
        innerShadow.shadowOpacity = shadowOpacity
        innerShadow.shadowRadius = shadowRadius
        innerShadow.cornerRadius = base.layer.cornerRadius
        base.layer.addSublayer(innerShadow)
    }
    
}

public extension PAExtensionNamespace where T == UIScrollView {
    
    func screenshot(inset: UIEdgeInsets = .zero, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: base.contentSize.width - inset.left - inset.right, height: base.contentSize.height - inset.top - inset.bottom), false, scale)
        let savedContentOffset = base.contentOffset
        let savedFrame = base.frame
        defer {
            UIGraphicsEndImageContext()
            base.contentOffset = savedContentOffset
            base.frame = savedFrame
        }
        base.contentOffset = .zero
        base.frame = CGRect(x: 0, y: 0, width: base.contentSize.width, height: base.contentSize.height).inset(by: inset)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        base.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
}
