//
//  PAScrollView.swift
//  SwiftPA
//
//  Created by 彭天明 on 2023/12/14.
//

import UIKit
import AVFoundation

extension String: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == String {
    
    static var appName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    static var userTrackingUsageDescription: String? {
        return Bundle.main.object(forInfoDictionaryKey: "NSUserTrackingUsageDescription") as? String
    }
    
    static func random(_ count: Int, _ isLetter: Bool = false) -> String {
        var ch: [CChar] = Array(repeating: 0, count: count)
        for index in 0..<count {
            var num = isLetter ? arc4random_uniform(58)+65:arc4random_uniform(75)+48
            if num>57 && num<65 && isLetter==false { num = num%57+48 }
            else if num>90 && num<97 { num = num%90+65 }
            ch[index] = CChar(num)
        }
        return String(cString: ch)
    }
    
    static func timeString(timeInterval: Double) -> String {
        let duration = Int(ceil(timeInterval))
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let hours = (duration / 3600)
        if (hours > 0) {
            return String(format: "%02li:%02li:%02li", hours, minutes, seconds)
        }else{
            return String(format: "%02li:%02li", minutes, seconds)
        }
    }
    
    static func string(num: Int) -> String {
        if num > 1000000 {
            return String.init(format: "%.1fM", CGFloat(num) / 1000000)
        }else if num > 1000 {
            return String.init(format: "%.1fK", CGFloat(num) / 1000)
        }else{
            return String.init(format: "%.0f", CGFloat(num))
        }
    }
    
}

public extension PAExtensionNamespace where T == String {
    
    func toRgba() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat?) {
        if base.isEmpty {
            return (0, 0, 0, nil)
        }
        var cString = base.pa.removeHeadAndTailSpacePro
        if cString.count == 0 {
            return (0, 0, 0, nil)
        }
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        let value = "0x\(cString)"
        let scanner = Scanner(string:value)
        var hex: UInt64 = 0
        guard scanner.scanHexInt64(&hex) else {
            return (0, 0, 0, nil)
        }
        let a: CGFloat?
        let r, g, b: CGFloat
        switch cString.count {
        case 3:
            r = CGFloat(hex >> 8) * 17
            g = CGFloat(hex >> 4 & 0xF) * 17
            b = CGFloat(hex & 0xF) * 17
            a = nil
        case 4:
            r = CGFloat(hex >> 12) * 17
            g = CGFloat(hex >> 8 & 0xF) * 17
            b = CGFloat(hex >> 4 & 0xF) * 17
            a = CGFloat(hex & 0xF) / 17
        case 6:
            r = CGFloat(hex >> 16)
            g = CGFloat(hex >> 8 & 0xFF)
            b = CGFloat(hex & 0xFF)
            a = nil
        case 8:
            r = CGFloat(hex >> 24)
            g = CGFloat(hex >> 16 & 0xFF)
            b = CGFloat(hex >> 8 & 0xFF)
            a = CGFloat(hex & 0xFF) / 255
        default:
            r = 0
            g = 0
            b = 0
            a = nil
        }
        return (r, g, b, a)
    }
    
    func size(attrs: [NSAttributedString.Key: Any], maxW: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let maxSize: CGSize = CGSize.init(width: maxW, height: .greatestFiniteMagnitude)
        return base.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    func size(font: UIFont, maxW: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        let attrs = [NSAttributedString.Key.font : font]
        return size(attrs: attrs, maxW: maxW)
    }
    
    func subString(to: Int) -> String {
        if to >= base.count {
            return base
        }
        return String(base.prefix(to))
    }

    func subString(from: Int) -> String {
        if from >= base.count {
            return ""
        }
        let startIndex = base.index(base.startIndex, offsetBy: from)
        let endIndex = base.endIndex
        return String(base[startIndex..<endIndex])
    }
    
    func subString(start: Int, end: Int) -> String {
        if start < end {
            let startIndex = base.index(base.startIndex, offsetBy: start)
            let endIndex = base.index(base.startIndex, offsetBy: end)
            return String(base[startIndex..<endIndex])
        }
        return ""
    }
    
    var capitalizingFirstLetter: String {
        return base.prefix(1).uppercased() + base.lowercased().dropFirst()
    }
    
    var removeHeadAndTailSpace: String {
        return base.trimmingCharacters(in: .whitespaces)
    }
    
    var removeHeadAndTailSpacePro: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isAlphanumeric() -> Bool {
        return !base.isEmpty && base.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isIncludeChinese: Bool {
        do {
            let matchs = try NSRegularExpression(pattern: "[\u{4e00}-\u{9fef}]+", options: .caseInsensitive).matches(in: base, range: .init(location: 0, length: base.count))
            return matchs.count > 0
        } catch {
            return false
        }
    }
    
    var isUrl: Bool {
        return base.hasPrefix("http")
    }
    
    var isEmail: Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: base)
    }
    
    var isVideoPath: Bool {
        if FileManager.default.fileExists(atPath: base) {
            let asset = AVAsset(url: URL(fileURLWithPath: base))
            let videoTracks = asset.tracks(withMediaType: .video)
            if asset.duration.value != 0 || videoTracks.count > 0 {
                return true
            }
        }
        return false
    }
    
    var isAudioPath: Bool {
        if FileManager.default.fileExists(atPath: base) {
            let asset = AVAsset(url: URL(fileURLWithPath: base))
            let audioTracks = asset.tracks(withMediaType: .audio)
            if asset.duration.value != 0 || audioTracks.count > 0 {
                return true
            }
        }
        return false
    }
    
    var wordCount: Int {
        return base.components(separatedBy: .whitespacesAndNewlines.union(.punctuationCharacters)).filter({ !$0.isEmpty }).count
    }
    
    var pathExtension: String {
        return (base as NSString).pathExtension
    }
    
    var lastPathComponent: String {
        return (base as NSString).lastPathComponent
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (base as NSString).appendingPathComponent(str)
    }
    
    func appendingPathExtension(_ str: String) -> String {
        return (base as NSString).appendingPathExtension(str) ?? (base + "." + str)
    }
    
}
