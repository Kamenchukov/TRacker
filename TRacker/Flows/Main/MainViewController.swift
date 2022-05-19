//
//  MainViewController.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBAction func showMap(_ sender: Any) {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        performSegue(withIdentifier: "logout", sender: sender)
    }
}
