//
//  RegisterViewController.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import UIKit

class RegisterViewController: UIViewController {

    let registerView = RegisterView()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "NeatMeet"
        
        self.view.backgroundColor = .white
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
        
       // registerView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
//    @objc func loginButtonTapped() {
//        dismiss(animated: true)
//    }
    
    @objc func registerButtonTapped(){
        if let nameText = registerView.nameText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let emailText = registerView.emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let passwordText = registerView.passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let confirmedPassword = registerView.confirmPasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            if nameText.isEmpty {
                showAlert(title: "All fields are mandatory!", message: "Please enter your name.")
                return
            }
            
            if emailText.isEmpty {
                showAlert(title: "All fields are mandatory!", message: "Please enter your email.")
                return
            }
            
            if !isValidEmail(emailText) {
                showAlert(title: "Invalid Email!", message: "Please enter a valid email.")
                return
            }
            
            if passwordText.isEmpty {
                showAlert(title: "All fields are mandatory!", message: "Please enter your password.")
                return
            }
            
            if passwordText.count < 6 {
                showAlert(title: "Incorrect Password Length", message: "Password should be of atleast length 6.")
                return
            }
            
            if passwordText != confirmedPassword {
                showAlert(title: "Passwords do not match!", message: "Please enter the correct password.")
                return
            }
            
            
            setLoading(true)
            registerNewAccount()
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func setLoading(_ loading: Bool) {
         //   registerView.loginButton.isEnabled = !loading
        if loading {
            registerView.activityIndicator.startAnimating()
          //      registerView.loginButton.setTitle("", for: .normal)
        } else {
            registerView.activityIndicator.stopAnimating()
         //       registerView.loginButton.setTitle("Login instead?", for: .normal)
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    

}
