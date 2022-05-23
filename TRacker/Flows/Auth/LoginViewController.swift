//
//  LoginViewController.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//


import UIKit

final class LoginViewController: UIViewController {
    enum Constants {
        static let login = "admin"
        static let password = "123456"
    }
    
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLogin") {
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        guard let login = loginView.text,
              let password = passwordView.text,
              login == Constants.login && password == Constants.password
        else { return }
        UserDefaults.standard.set(true, forKey: "isLogin")
        performSegue(withIdentifier: "toMain", sender: sender)
    }
    
    @IBAction func recovery(_ sender: Any) {
        performSegue(withIdentifier: "onRecover", sender: sender)
    }
}
