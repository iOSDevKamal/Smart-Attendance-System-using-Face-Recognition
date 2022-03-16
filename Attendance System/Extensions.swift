//
//  Extensions.swift
//  Attendance System
//
//  Created by Kamal Trapasiya on 2021-08-03.
//

import UIKit
import SkyFloatingLabelTextField

extension UIView {
    func gradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map({ color in
            return color.cgColor
        })
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension SkyFloatingLabelTextField {
    func applyCommonDesign() {
        self.selectedTitleColor = UIColor.white
        self.selectedLineHeight = 1
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}

extension UITextField {
    func isValidate() -> Bool {
        if self.text!.count == 0 {
            return false
        }
        else if self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        else {
            return true
        }
    }
}
