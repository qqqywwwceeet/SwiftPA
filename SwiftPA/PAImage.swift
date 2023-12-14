//
//  PAScrollView.swift
//  SwiftPA
//
//  Created by 云天明 on 2023/12/14.
//

import UIKit
import AVFoundation

extension UIImage: PAExtensionWrappable {}

public extension PAExtensionNamespace where T == UIImage {
    
    static func fromLayer(layer: CALayer) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = layer.isOpaque
        return UIGraphicsImageRenderer(size: layer.bounds.size, format: format).image { context in
            layer.render(in: context.cgContext)
        }
    }
    
    static func colored(hex: String, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { context in
            UIColor.pa.hex(hex).setFill()
            context.fill(.init(origin: .zero, size: size))
        }
    }
    
    static func linearColored(hexs: [String], start: CGPoint, end: CGPoint, locations: [CGFloat] = [0, 1], size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = hexs.map { return CGColor.pa.hex($0) } as NSArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: locations) else {
            return nil
        }
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.drawLinearGradient(gradient, start: CGPoint(x: start.x * size.width, y: start.y * size.height), end: CGPoint(x: end.x * size.width, y: end.y * size.height), options: .drawsBeforeStartLocation)
        }
    }
    
    static func videoFirstFrame(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil) {
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    static func colorBgAndCenterImage(color: UIColor, size: CGSize, centerImage: UIImage?) -> UIImage? {
        guard let centerImage = centerImage else {return nil}
        let background = UIView.init(frame: CGRect.init(x: 0, y: 0, width: floor(size.width), height: floor(size.height)))
        background.backgroundColor = color
        
        let imageView = UIImageView(image: centerImage)
        background.addSubview(imageView)
        imageView.center = background.center
        
        return .pa.fromLayer(layer: imageView.layer)
    }
    
    static var icon: UIImage? {
        if let infoPlist = Bundle.main.infoDictionary {
            if let dic1 = infoPlist["CFBundleIcons"] as? [String: Any] {
                if let dic2 = dic1["CFBundlePrimaryIcon"] as? [String: Any] {
                    if let icons = dic2["CFBundleIconFiles"] as? [String] {
                        if let iconName = icons.last {
                            return UIImage(named: iconName)
                        }
                    }
                }
            }
        }
        return nil
    }
    
}

public extension PAExtensionNamespace where T == UIImage {
    
    func colored(hex: String) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        let image = base.withRenderingMode(.alwaysTemplate)
        return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
            UIColor.pa.hex(hex).set()
            image.draw(in: .init(origin: .zero, size: image.size))
        }
    }
    
    func relinearColored(hexs: [String], start: CGPoint, end: CGPoint, locations: [CGFloat] = [0, 1]) -> UIImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgColors = hexs.map { return CGColor.pa.hex($0) } as NSArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: locations) else {
            return nil
        }
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        let image = base.withRenderingMode(.alwaysTemplate)
        return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
            context.cgContext.drawLinearGradient(gradient, start: CGPoint(x: start.x * image.size.width, y: start.y * image.size.height), end: CGPoint(x: end.x * image.size.width, y: end.y * image.size.height), options: .drawsBeforeStartLocation)
            image.draw(in: .init(origin: .zero, size: image.size))
        }
    }
    
    func cliped(ratio: CGFloat) -> UIImage {
        var newSize: CGSize = CGSize(width: base.size.width, height: base.size.width / ratio)
        if base.size.width / base.size.height > ratio {
            newSize = CGSize(width: base.size.height * ratio, height: base.size.height)
        }
        var rect = CGRect.zero
        rect.size.width = base.size.width
        rect.size.height = base.size.height
        rect.origin.x = (newSize.width - base.size.width ) / 2.0
        rect.origin.y = (newSize.height - base.size.height ) / 2.0
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: newSize, format: format).image { context in
            base.draw(in: rect)
        }
    }
    
    func cliped(insets: UIEdgeInsets) -> UIImage {
        let size = CGSize(width: base.size.width - insets.left - insets.right, height: base.size.height - insets.top - insets.bottom)
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            base.draw(in: .init(x: -insets.left, y: -insets.top, width: size.width, height: size.height))
        }
    }
    
    func resized(size: CGSize) -> UIImage {
        let originalWidth = base.size.width
        let originalHeight = base.size.height
        var targetWidth = size.width
        var targetHeight = originalHeight / originalWidth * targetWidth
        if targetHeight > size.height {
            targetHeight = size.height
            targetWidth = originalWidth / originalHeight * targetHeight
        }
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { context in
            base.draw(in: .init(origin: .zero, size: targetSize))
        }
    }
    
    func scaleToMaxSize(size: CGSize) -> UIImage? {
        if base.size.width < size.width && base.size.height < size.height {
            return base.copy() as? UIImage
        }
        let widthScale = size.width / base.size.width
        let heightScale = size.height / base.size.height
        let scale = min(widthScale, heightScale)
        let targetSize = CGSize.init(width: base.size.width * scale, height: base.size.height * scale)
        return resized(size: targetSize)
    }
    
    func resizable(inset: UIEdgeInsets) -> UIImage {
        return base.resizableImage(withCapInsets: inset, resizingMode: .stretch)
    }
    
    func flipHorizontal() -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
            let rect = CGRect(origin: .zero, size: base.size)
            context.cgContext.clip(to: [rect])
            context.cgContext.rotate(by: .pi)
            context.cgContext.translateBy(x: -base.size.width, y: -base.size.height)
            context.cgContext.draw(cgImage, in: rect)
        }
    }
    
    func flipVertical() -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        let format = UIGraphicsImageRendererFormat()
        format.scale = base.scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: base.size, format: format).image { context in
            let rect = CGRect(origin: .zero, size: base.size)
            context.cgContext.clip(to: [rect])
            context.cgContext.draw(cgImage, in: rect)
        }
    }
    
    func fixOrientation() -> UIImage? {
        let orientation = base.imageOrientation
        if orientation == .up {
            return base
        }
        guard let cgImage = base.cgImage else { return base }
        var transform = CGAffineTransform.identity
        switch orientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: base.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: base.size.height)
            transform = transform.rotated(by: .pi / -2)
        default:
            break
        }

        switch orientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: base.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: base.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let context = CGContext(data: nil, width: Int(base.size.width), height: Int(base.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
        context?.concatenate(transform)
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.height, height: base.size.width))
        default:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height))
        }
        guard let cgimg = context?.makeImage() else {
            return base
        }
        let result = UIImage(cgImage: cgimg)
        return result
    }
}
