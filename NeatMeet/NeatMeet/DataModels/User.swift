//
//  User.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/22/24.
//
import FirebaseAuth
struct User {
    var id: UUID
    var email: String
    var name: String
    
    init(email: String, name: String, id: UUID) {
          self.id = id
          self.email = email
          self.name = name
        
      }
      
    init(from firebaseUser: FirebaseAuth.User) {
        self.init(email: firebaseUser.email ?? "", name: firebaseUser.displayName ?? "Unknown", id: UUID())
      }
}
