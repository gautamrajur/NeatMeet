//
//  LoginViewController.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import UIKit

class LoginViewController: UIViewController {

    let loginView = LoginView()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NeatMeet"
        
        self.view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func registerButtonTapped() {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
    @objc func loginButtonTapped() {
//        if let emailText = loginView.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
//           let passwordText = loginView.passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
//            
//            if !isValidEmail(emailText) {
//                showAlert(title: "Invalid Email!", message: "Please enter a valid email address.")
//                return
//            }
//            
//            if passwordText.isEmpty {
//                showAlert(title: "Password cannot be empty!", message: "Please enter password.")
//                return
//            }
            
     //       setLoading(true)
        
        notificationCenter.post(name: .loggedIn, object: nil)
        dismiss(animated: true)
            
    }
    
    func setLoading(_ loading: Bool) {
        loginView.loginButton.isEnabled = !loading
        if loading {
            loginView.activityIndicator.startAnimating()
            loginView.loginButton.setTitle("", for: .normal)
        } else {
            loginView.activityIndicator.stopAnimating()
            loginView.loginButton.setTitle("Login", for: .normal)
        }
    }

}
