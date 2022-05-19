//
//  RecoveryPasswordViewController.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import UIKit

final class RecoveryPasswordViewController: UIViewController {
    
    @IBOutlet weak var loginView: UITextField!
    
    @IBAction func recovery(_ sender: Any) {
        guard let login = loginView.text,
              login == LoginViewController.Constants.login
        else {
            return
        }
        showPassword()
    }
    
    private func showPassword() {
        let allert = UIAlertController(title: "Пароль", message: "123456", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .cancel)
        allert.addAction(ok)
        present(allert, animated: true)
    }
}
