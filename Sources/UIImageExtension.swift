//
//  UIImageExtension.swift
//  chaatz
//
//  Created by Mingloan Chan on 3/11/17.
//  Copyright © 2017 Chaatz. All rights reserved.
//

import UIKit

extension UIImage {
    
    func tintTemplateImage(_ color: UIColor, bitmapContextColor: UIColor = UIColor.clear) -> UIImage {
        
        var image = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(
            self.size,
            false,
            self.scale)
        
        bitmapContextColor.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: self.size))
        
        color.set()
        image.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // colorize image with given tint color
    // this is similar to Photoshop's "Color" layer blend mode
    // this is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved
    // white will stay white and black will stay black as the lightness of the image is preserved
    func tint(_ tintColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)
            
            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)
            
            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    // fills the alpha channel of the source image with the given color
    // any color information except to the alpha channel will be ignored
    func fillAlpha(_ fillColor: UIColor) -> UIImage {
        
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            
            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        
        // correctly rotate image
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        draw(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     Crop Center Square From Image
     - Parameter ratio:   The ratio of rect to crop.
     - Returns: A new cropped image.
     */
    func centerArea(withRatio ratio: CGFloat) -> UIImage {
        
        let refWidth: CGFloat = CGFloat(cgImage!.width)
        let refHeight: CGFloat = CGFloat(cgImage!.height)
        
        if refWidth == 0 || refHeight == 0 {
            return self
        }
        
        let imageEdgeRatio = refWidth/refHeight
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        if imageEdgeRatio > ratio {
            height = refHeight
            width = height * ratio
        }
        else {
            width = refWidth
            height = width/ratio
        }
        
        let x = (refWidth - width) / 2
        let y = (refHeight - height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: ceil(width), height: ceil(height))
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            let cropped = UIImage(cgImage: imageRef, scale: 0, orientation: imageOrientation)
            return cropped
        }
        return self
    }
    
    /**
     Crop Center Square From Image
     - Returns: A new cropped image.
     */
    func centerSquareArea() -> UIImage {
        
        let refWidth: CGFloat = CGFloat(cgImage!.width)
        let refHeight: CGFloat = CGFloat(cgImage!.height)
        
        if refWidth == 0 || refHeight == 0 {
            return self
        }
        
        let edgeSize: CGFloat = min(refWidth, refHeight)
        
        let x = (refWidth - edgeSize) / 2
        let y = (refHeight - edgeSize) / 2
        
        let cropRect = CGRect(x: x, y: y, width: edgeSize, height: edgeSize)
        if let imageRef = self.cgImage!.cropping(to: cropRect) {
            let cropped = UIImage(cgImage: imageRef, scale: 0, orientation: imageOrientation)
            return cropped
        }
        return self
    }
    
    func cropImageFromCenter(_ toSize: CGSize) -> UIImage? {
        
        if toSize.width == 0 || toSize.height == 0 || size.width == 0 || size.height == 0 {
            return nil
        }
        
        let scale = UIScreen.main.scale
        let x = (size.width - toSize.width) / 2
        let y = (size.height - toSize.height) / 2
        let cropRect = CGRect(x: x, y: y, width: toSize.width * scale, height: toSize.height * scale)
        
        let imageRef = cgImage!.cropping(to: cropRect)
        let cropped = UIImage(cgImage: imageRef!)
        
        return cropped
    }
    
    func crop(_ rect: CGRect) -> UIImage {
        
        let cropRect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.size.width * scale,
            height: rect.size.height * scale)
        
        guard let imageRef = cgImage!.cropping(to: cropRect) else { return self }
        
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return result
    }
    
    func imagePattern(_ size: CGSize) -> UIImage? {
        
        if size.width == 0 || size.height == 0 {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        UIColor(patternImage: self).setFill()
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    /**
     Resize Image
     - Parameter str:   The string to repeat.
     - Parameter times: The number of times to repeat `str`.
     - Throws: `MyError.InvalidTimes` if the `times` parameter
     is less than zero.
     - Returns: A new string with `str` repeated `times` times.
     */
    func aspectFillResize(_ filledSize: CGSize) -> UIImage? {
        if filledSize.width > filledSize.height {
            if filledSize.width/filledSize.height > size.width/size.height {
                return centerSquareArea().resize(filledSize.width)
            }
            else {
                return centerSquareArea().resize(byHeight: filledSize.height)
            }
        }
        else {
            return centerSquareArea().resize(byHeight: filledSize.height)
        }
    }
    
    func resize(_ newWidth: CGFloat) -> UIImage? {
        
        if size.width == 0 || size.height == 0 {
            return nil
        }
        
        let ratio = newWidth / size.width
        let newHeight = size.height * ratio
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resize(byHeight newHeight: CGFloat) -> UIImage? {
        
        if size.width == 0 || size.height == 0 {
            return nil
        }
        
        let ratio = newHeight / size.height
        let newWidth = size.width * ratio
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: newWidth, height: newHeight), false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func orientationForFlippingHorizontally(source isCGImage: Bool) -> UIImageOrientation {
        switch imageOrientation {
        case .up:
            return isCGImage ? .downMirrored : .upMirrored
        case .down:
            return isCGImage ? .upMirrored : .downMirrored
        case .left:
            return isCGImage ? .rightMirrored : .leftMirrored
        case .right:
            return isCGImage ? .leftMirrored : .rightMirrored
        case .upMirrored:
            return isCGImage ? .down : .up
        case .downMirrored:
            return isCGImage ? .up : .down
        case .leftMirrored:
            return isCGImage ? .right : .left
        case .rightMirrored:
            return isCGImage ? .left : .right
        }
    }
    
}
