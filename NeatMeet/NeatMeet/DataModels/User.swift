//
//  User.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/22/24.
//
import FirebaseAuth
struct User {
    var id: String
    var email: String
    var name: String
    var imageUrl: String
    
    init(email: String, name: String, id: String, imageUrl: String) {
          self.id = id
          self.email = email
          self.name = name
        self.imageUrl =  imageUrl
      }
      
    init(from firebaseUser: FirebaseAuth.User) {
        self.init(email: firebaseUser.email ?? "", name: firebaseUser.displayName ?? "Unknown", id: "", imageUrl: "")
      }
}
