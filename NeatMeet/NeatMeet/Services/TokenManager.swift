//
//  TokenManager.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "auth_token"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
