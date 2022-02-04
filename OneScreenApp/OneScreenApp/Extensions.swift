//
//  Ex.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 2.02.22.
//

import UIKit

extension UIColor {

    func colorFromHexString (_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    func setupCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }

    func setupShadow(_ color: UIColor, _ offset: CGSize, _ radius: CGFloat, opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }

    func addInnerShadow(_ color: UIColor, _ offset: CGSize, _ radius: CGFloat, opacity: Float) {
        let innerShadow = CALayer()
        innerShadow.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height + 12)

        // Shadow path (1pt ring around bounds)
        let radius = self.layer.cornerRadius
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: 2, dy: 2), cornerRadius: radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius: radius).reversing()

        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true

        // Shadow properties
        innerShadow.shadowColor = color.cgColor
        innerShadow.shadowOffset = offset
        innerShadow.shadowOpacity = opacity
        innerShadow.shadowRadius = radius
        innerShadow.cornerRadius = self.layer.cornerRadius
        layer.addSublayer(innerShadow)
    }
}
