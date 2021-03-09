//
//  UIView+Screenshot.swift
//  SliderImages
//
//  Created by 刘Sir on 2021/3/9.
//

import UIKit
extension UIView {
    //将当前视图转为UIImage
        func asImage() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale);
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return image!
        }
}
