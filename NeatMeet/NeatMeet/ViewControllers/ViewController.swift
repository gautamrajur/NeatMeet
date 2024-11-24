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
        if let currentUser = Auth.auth().currentUser {
            // User is logged in
            UserManager.shared.loggedInUser = User(
                email: currentUser.email ?? "",
                name: currentUser.displayName ?? "Unknown",
                id: currentUser.uid,
                imageUrl: ""
            )
            navigateToLandingScreen()
        } else {
            // User is not logged in
            print("Calling login screen")
            navigateToLoginScreen()
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
