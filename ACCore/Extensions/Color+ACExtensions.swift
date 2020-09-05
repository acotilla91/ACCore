//
//  Color+ACExtensions.swift
//
//  Created by Alejandro Cotilla on 10/20/17.
//  Copyright © 2017 Carolco LLC. All rights reserved.
//

#if os(OSX)
    import AppKit
    typealias Color = NSColor
#elseif os(iOS) || os(tvOS)
    import UIKit
    typealias Color = UIColor
#endif

extension Color {

    /// Initializes a color object using the specified hex and opacity value.
    /// - Parameters:
    ///   - hex: The hex value for the color object as a `String`.
    ///   - alpha: The opacity value for the color object, specified as a value from `0.0` to `1.0`. Default is `1.0`.
    ///
    /// ````
    /// // Example
    /// let color = NSColor(hex: "#FFFFFF")
    /// let color = NSColor(hex: "#FFFFFF", alpha: 0.5)
    /// let color = NSColor(hex: "#FFFFFF80")
    /// ````
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if hexFormatted.hasPrefix("#") {
            let index = hexFormatted.index(hexFormatted.startIndex, offsetBy: 1)
            hexFormatted = String(hexFormatted[index...])
        }
        
        assert(hexFormatted.count == 6 || hexFormatted.count == 8, "Invalid hex code used.")

        var rgb: UInt32 = 0
        Scanner(string: hexFormatted).scanHexInt32(&rgb)
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = alpha
        
        let length = hexFormatted.count
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        }
        else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    /// Initializes and returns a random color object using the specified opacity value.
    /// - Parameter alpha: The opacity value for the color object, specified as a value from `0.0` to `1.0`. Default is `1.0`.
    /// - Returns: The color object.
    ///
    /// ````
    /// // Example
    /// let color = NSColor.randomColor()
    /// let color = NSColor.randomColor(withAlpha: 0.5)
    /// ````
    ///
    /// - Note: Stack Overflow: [How to make a random background color with Swift](https://stackoverflow.com/a/29779319/2108547).
    class func randomColor(withAlpha alpha: CGFloat = 1.0) -> Color {
        let red = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let green = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let blue = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        return Color(red:red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }

    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }

    /**
     Try to increase brightness or decrease saturation
     Based on: https://stackoverflow.com/a/42381754/1792699
     */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
}
