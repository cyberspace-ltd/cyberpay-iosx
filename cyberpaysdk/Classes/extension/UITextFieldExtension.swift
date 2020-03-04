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
    
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: -10, y: 5, width: 25, height: 25))
       iconView.image = image
        iconView.contentMode = .scaleAspectFit
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: -20, y: 0, width: 35, height: 35))
       iconContainerView.addSubview(iconView)
       rightView = iconContainerView
       rightViewMode = .always
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
    
    func setBottomBorderOnlyWith(color: CGColor) {
           self.borderStyle = .none
           self.layer.masksToBounds = false
           self.layer.shadowColor = color
           self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           self.layer.shadowOpacity = 1.0
           self.layer.shadowRadius = 0.0
       }
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")

        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
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
    
    
    func getCyberpayImage() -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        return UIImage(named: "cyberpay-logo", in: bundle, compatibleWith: nil)
    }

}
