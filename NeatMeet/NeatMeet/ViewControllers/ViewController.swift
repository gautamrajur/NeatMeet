//
//  ViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/21/24.
//

import FirebaseFirestore
import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
           super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser{
            
            if currentUser == nil {
                print("calling logging screen")
                navigateToLoginScreen()
            } else {
                
                UserManager.shared.loggedInUser = User(
                    email: currentUser.email ?? "",
                    name: currentUser.displayName ?? "Unknown",
                    id: currentUser.uid,
                    imageUrl: ""
                )
                navigateToLandingScreen()
            }
        }
       }

       private func navigateToLandingScreen() {
           let landingVC = LandingViewController()
           navigationController?.setViewControllers([landingVC], animated: true)
       }

       private func navigateToLoginScreen() {
           let loginVC = LoginViewController()
           navigationController?.setViewControllers([loginVC], animated: true)
       }

}
