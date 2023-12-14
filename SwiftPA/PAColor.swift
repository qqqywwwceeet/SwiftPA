//
//  PAScrollView.swift
//  SwiftPA
//
//  Created by 云天明 on 2021/1/22.
//

import UIKit

extension UIColor: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == UIColor {
    
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    static func hsb(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    static func hex(_ hex: String, _ alpha: CGFloat? = nil) -> UIColor {
        let value = hex.pa.toRgba()
        return rgba(value.r, value.g, value.b, alpha ?? value.a ?? 1)
    }
    
    static func middleColor(from: String, to: String, distance: CGFloat) -> UIColor {
        let fromRgba = from.pa.toRgba()
        let toRgba = to.pa.toRgba()
        let fromA = fromRgba.a ?? 1
        let toA = toRgba.a ?? 1
        
        let r = fromRgba.r + (toRgba.r - fromRgba.r) * distance
        let g = fromRgba.g + (toRgba.g - fromRgba.g) * distance
        let b = fromRgba.b + (toRgba.b - fromRgba.b) * distance
        let a = fromA + (toA - fromA) * distance
        
        return rgba(r, g, b, a)
    }
    
}

public extension PAExtensionNamespace where T == UIColor {
    
    var hexString: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
}


extension CGColor: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == CGColor {
    
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
        return CGColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
    
    static func hsb(_ h: CGFloat, _ s: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
        return UIColor.pa.hsb(h, s, b, a).cgColor
    }
    
    static func hex(_ hex: String, _ alpha: CGFloat? = nil) -> CGColor {
        let value = hex.pa.toRgba()
        return rgba(value.r, value.g, value.b, alpha ?? value.a ?? 1)
    }
    
    static func middleColor(from: String, to: String, distance: CGFloat) -> CGColor {
        let fromRgba = from.pa.toRgba()
        let toRgba = to.pa.toRgba()
        let fromA = fromRgba.a ?? 1
        let toA = toRgba.a ?? 1
        
        let r = fromRgba.r + (toRgba.r - fromRgba.r) * distance
        let g = fromRgba.g + (toRgba.g - fromRgba.g) * distance
        let b = fromRgba.b + (toRgba.b - fromRgba.b) * distance
        let a = fromA + (toA - fromA) * distance
        
        return rgba(r, g, b, a)
    }
    
}
