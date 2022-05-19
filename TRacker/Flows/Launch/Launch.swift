//
//  Launch.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import UIKit

class Launch: UIViewController {
    
    @IBOutlet var router: LaunchRouter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

final class LaunchRouter: BaseRouter {
    func toMain() {
        perform(segue: "toMain")
    }
    
    func toAuth() {
        perform(segue: "toAuth")
    }
}
