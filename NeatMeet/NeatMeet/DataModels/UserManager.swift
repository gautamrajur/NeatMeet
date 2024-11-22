//
//  UserManager.swift
//  NeatMeet
//
//  Created by Saniya Anklesaria on 11/22/24.
//


class UserManager {
    static let shared = UserManager()
    
    var loggedInUser: User?
    
    private init() {} 
}
