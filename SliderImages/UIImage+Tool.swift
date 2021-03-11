//
//  UIImage+cut.swift
//  SliderImages
//
//  Created by 刘Sir on 2021/3/11.
//

import UIKit
extension UIImage {
    func getImageFromRect(_ rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.width, height: rect.height), false, 0)
        self.draw(at: CGPoint(x: -rect.minX, y: -rect.minY))
        guard let im = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return im
    }
    
    class func combine(_ leftImage: UIImage, rightImage: UIImage) -> UIImage {
        let width = leftImage.size.width
        let height = leftImage.size.height
        UIGraphicsBeginImageContext(CGSize(width: 2*width, height: height))
        leftImage.draw(at: CGPoint(x: 0, y: 0))
        rightImage.draw(at: CGPoint(x: width-0.1, y: 0))
        guard let imageLong = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        return imageLong
    }
    class func resizeImage(_ originImage: UIImage, targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(targetSize);
        originImage.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}
