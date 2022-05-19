//
//  User.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import Foundation
import RealmSwift


class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override static func primaryKey() -> String? {
        return "login"
    }
    
    convenience init(login: String, password: String) {
        self.init()
        
        self.login = login
        self.password = password
    }
}
