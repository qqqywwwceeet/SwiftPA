//
//  PAFileManager.swift
//  SwiftPA
//
//  Created by 彭天明 on 2023/12/14.
//

import UIKit

extension FileManager: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == FileManager {
    
    static var cacheDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    
    static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    static var tempDirectory: String {
        return NSTemporaryDirectory()
    }
    
    static func remove(filePath: String) {
        guard FileManager.default.fileExists(atPath: filePath) else {return}
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    static func create(directory: String) {
        guard !FileManager.default.fileExists(atPath: directory) else {return}
        try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
    }
    
}
