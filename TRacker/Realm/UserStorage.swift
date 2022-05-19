//
//  UserStorage.swift
//  TRacker
//
//  Created by Константин Каменчуков on 14.05.2022.
//

import Foundation
import RealmSwift

class UserStorage {
    
    static var shared = UserStorage()
    private var realm = try! Realm()
    
    private init() {  }
    
    public func addUser(_ user: User) -> Bool {
        if isUserExist(user: user) {
            return false
        } else {
            createUser(user)
            return true
        }
    }
    
    private func createUser(_ user: User) {
        try? realm.write {
            realm.add(user)
        }
    }
    
    func isUserExist(user: User) -> Bool {
        guard let databaseUser = realm.object(ofType: User.self, forPrimaryKey: user.login) else { return false }
        
        if user.password == databaseUser.password {
            return true
        } else {
            return false
        }
    }
}
