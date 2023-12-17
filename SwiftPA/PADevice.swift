//
//  PADevice.swift
//  SwiftPA
//
//  Created by 云天明 on 2023/12/14.
//

import UIKit

extension UIDevice: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == UIDevice {
    
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
}
