//
//  SimpleRView.swift
//  CyberpaySdk
//
//  Created by Sunday Okpoluaefe on 1/14/20.
//  Copyright © 2020 cyberspace. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class SimpleRView: UIView {
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
