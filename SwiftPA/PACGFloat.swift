//
//  PACGFloat.swift
//  SwiftPA
//
//  Created by 彭天明 on 2023/12/17.
//

import UIKit

extension CGFloat: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == CGFloat {
    
    /**
    notch: 有刘海的手机
    noNoth: 无刘海的手机
    */
    static func sX(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, _ pad: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let designWidth = PAConfig.shared.designWidth
        if UIDevice.pa.isPad {
            return (pad == .greatestFiniteMagnitude ? notch : pad) * (width / designWidth)
        }
        if UIDevice.pa.hasNotch || noNotch == .greatestFiniteMagnitude {
            return notch * (width / designWidth)
        } else {
            return noNotch * (width / designWidth)
        }
    }

    static func sY(_ notch: CGFloat, _ noNotch: CGFloat = .greatestFiniteMagnitude, _ pad: CGFloat = .greatestFiniteMagnitude) -> CGFloat {
        let height = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let designHeight = PAConfig.shared.designHeight
        if UIDevice.pa.isPad {
            return (pad == .greatestFiniteMagnitude ? notch : pad) * (height / designHeight)
        }
        if UIDevice.pa.hasNotch || noNotch == .greatestFiniteMagnitude {
            return notch * (height / designHeight)
        } else {
            return noNotch * (height / designHeight)
        }
    }
    
    static var statusBarHeight: CGFloat {
        if let top = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height {
            return top
        }
        if let top = UIApplication.shared.windows.first?.safeAreaInsets.top, top > 0 {
            return top
        }
        return 44
    }
    
    static var bottomNotchHeight: CGFloat {
        if let height = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            return height
        }
        return 34
    }
    
}
