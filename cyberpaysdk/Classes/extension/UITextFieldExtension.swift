//
//  UITextFieldExtension.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 1/9/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
          return leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        
        
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                let paddingSize = rightView?.frame.size.width ?? 0

                if activityIndicator == nil {
                    let _activityIndicator = UIActivityIndicatorView(style: .gray)
                    _activityIndicator.startAnimating()
                    _activityIndicator.backgroundColor = UIColor.clear
                    let clearImage = UIImage().imageWithPixelSize(size: CGSize.init(width: 14, height: 14)) ?? UIImage()
                    self.setView(UITextField.ViewType.right, image: clearImage)
                    _activityIndicator.tag = 100
                    rightViewMode = .always
                    rightView?.addSubview(_activityIndicator)
                    _activityIndicator.center = CGPoint(x:  -paddingSize , y: paddingSize)
                }
            } else {
                rightView?.viewWithTag(100)?.removeFromSuperview()
            }
        }
    }
}

extension UIImage {
    func imageWithPixelSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, opaque: Bool = false) -> UIImage? {
        return imageWithSize(size: size, filledWithColor: color, scale: 1.0, opaque: opaque)
    }

    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
