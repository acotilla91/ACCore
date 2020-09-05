//
//  UIApplication+ACExtensions.swift
//
//  Created by Alejandro Cotilla on 3/4/19.
//  Copyright © 2019 Carolco LLC. All rights reserved.
//

import UIKit

extension UIApplication {
    
    // Based on: https://stackoverflow.com/a/50656239/1792699
    class func topMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return base
    }
}
