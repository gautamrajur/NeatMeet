//
//  LoginViewController.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    let loginView = LoginView()
    let notificationCenter = NotificationCenter.default
    var onLoginSuccess: (() -> Void)?
    let defaults = UserDefaults.standard

    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NeatMeet"
        self.navigationItem.hidesBackButton = true
        
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
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func loginButtonTapped() {
        if let emailText = loginView.emailText.text?.trimmingCharacters(
                in: .whitespacesAndNewlines),
                let passwordText = loginView.passwordText.text?.trimmingCharacters(
                    in: .whitespacesAndNewlines)
            {
                if !isValidEmail(emailText) {
                    showAlert(
                        title: "Invalid Email!",
                        message: "Please enter a valid email address.")
                    return
                }
                if passwordText.isEmpty {
                    showAlert(
                        title: "Password cannot be empty!",
                        message: "Please enter password.")
                    return
                }
                setLoading(true)
                self.signInToFirebase(email: emailText, password: passwordText)
            }
            
    }
    
    func signInToFirebase(email: String, password: String) {
        Auth.auth().signIn(
            withEmail: email, password: password,
            completion: { (result, error) in
                if error == nil {
                    print("login successful")
                    self.setLoading(false)
                    self.notificationCenter.post(name: .loggedIn, object: nil)
                    self.onLoginSuccess?()
                   
                    if let currentUser = Auth.auth().currentUser {
                        UserManager.shared.loggedInUser = User(
                            email: currentUser.email ?? "",
                            name: currentUser.displayName ?? "Unknown",
                            id: currentUser.uid,
                            imageUrl: ""
                        )
                    }
                    let viewController = LandingViewController()
                    self.navigationController?.setViewControllers([viewController], animated: true)
                } else {
                    self.setLoading(false)
                    print("Error occured: \(String(describing: error))")
                    self.showAlert(
                        title: "Error!", message: "Incorrect credentials")
                }
            })
        }
    
    
    
    

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
