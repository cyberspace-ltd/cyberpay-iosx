/*
Copyright (c) 2017 Mastercard

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 
REFERENCE: https://github.com/simplifycom/simplify-ios-sdk-swift/blob/master/Simplify-SDK-Swift/Simplify-SDK-Swift/Internal/System%20Extensions/UIView%2BSuperViewHugging.swift
*/

import Foundation
import UIKit

struct UIViewEdges: OptionSet {
    var rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let top = UIViewEdges(rawValue: 1 << 0)
    static let bottom = UIViewEdges(rawValue: 1 << 1)
    static let leading = UIViewEdges(rawValue: 1 << 2)
    static let trailing = UIViewEdges(rawValue: 1 << 3)
    static let left = UIViewEdges(rawValue: 1 << 4)
    static let right = UIViewEdges(rawValue: 1 << 5)
    static let allLaunguageDirectional: UIViewEdges = [.top, .bottom, .leading, .trailing]
    static let allFixed: UIViewEdges = [.top, .bottom, .left, .right]
    
    
}

extension UIView {
    func superviewHuggingConstraints(insets: UIEdgeInsets = UIEdgeInsets.zero, edges: UIViewEdges = .allLaunguageDirectional, useMargins: Bool = true, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: superview, attribute: (useMargins ? .topMargin : .top), multiplier: 1, constant: insets.top))
        }
        if edges.contains(.bottom) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: relation, toItem: superview, attribute: (useMargins ? .bottomMargin : .bottom), multiplier: 1, constant: insets.bottom))
        }
        if edges.contains(.leading) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: relation, toItem: superview, attribute: (useMargins ? .leadingMargin : .leading), multiplier: 1, constant: insets.left))
        }
        if edges.contains(.trailing) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: relation, toItem: superview, attribute: (useMargins ? .trailingMargin : .trailing), multiplier: 1, constant: insets.right))
        }
        if edges.contains(.left) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .left, relatedBy: relation, toItem: superview, attribute: (useMargins ? .leftMargin : .left), multiplier: 1, constant: insets.left))
        }
        if edges.contains(.right) {
            constraints.append(NSLayoutConstraint(item: self, attribute: .right, relatedBy: relation, toItem: superview, attribute: (useMargins ? .rightMargin : .right), multiplier: 1, constant: insets.right))
        }
        return constraints
    }
}



extension UIView {
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIView {
    func circleCorner() {
        superview?.layoutIfNeeded()
        setCorner(radius: frame.height / 2)
    }
}

extension UIView {
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}

extension UITextField {
    enum ViewType {
        case left, right
    }
    
    // (1)
    func setView(_ type: ViewType, with view: UIView) {
        if type == ViewType.left {
            leftView = view
            leftViewMode = .always
        } else if type == .right {
            rightView = view
            rightViewMode = .always
        }
    }
    
    // (2)
    @discardableResult
    func setView(_ view: ViewType, title: String, space: CGFloat = 0) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: frame.height))
        button.setTitle(title, for: UIControl.State())
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: space, bottom: 4, right: space)
        button.sizeToFit()
        setView(view, with: button)
        return button
    }
    
    @discardableResult
    func setView(_ view: ViewType, image: UIImage?, width: CGFloat = 50) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        button.setImage(image, for: .normal)
        button.imageView!.contentMode = .scaleToFill
        setView(view, with: button)
        return button
    }
    @discardableResult
    func setView(_ view: ViewType, space: CGFloat) -> UIView {
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: space, height: 1))
        setView(view, with: spaceView)
        return spaceView
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


extension UIViewController: UIPopoverPresentationControllerDelegate {
    func presentOnRoot(with viewController : UIViewController){
        self.navigationItem.backBarButtonItem?.title = "Yaga"
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    @objc private func dismissPopover() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
