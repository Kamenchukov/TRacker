//
//  UIWindow + keyWindow.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = windowScene.delegate as? SceneDelegate {
                return delegate.window
            }
        } else {
            return UIApplication.shared.keyWindow
        }
        return nil
    }
}
