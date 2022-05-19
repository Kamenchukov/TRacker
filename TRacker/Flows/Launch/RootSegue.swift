//
//  RootSegue.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import UIKit

class RootSegue: UIStoryboardSegue {
    override func perform() {
        UIWindow.keyWindow?.rootViewController = destination
    }
}
