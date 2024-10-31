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
        
        registerView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }
    
    @objc func loginButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func registerButtonTapped(){
        notificationCenter.post(name: .registered, object: nil)
    }

}
