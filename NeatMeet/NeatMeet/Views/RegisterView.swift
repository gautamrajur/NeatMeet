//
//  RegisterView.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import UIKit

class RegisterView: UIView {

    var scrollView: UIScrollView!
    var contentWrapper: UIView!
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var nameText: UITextField!
    var emailText: UITextField!
    var passwordText: UITextField!
    var confirmPasswordText: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    var activityIndicator: UIActivityIndicatorView!
    var bottomImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .white
        
        setupScrollView()
        setupContentWrapper()
        setupLogoImageView()
        setUpTitleLabel()
        setUpNameTextField()
        setUpEmailTextField()
        setUpPasswordTextField()
        setUpConfirmPasswordTextField()
       // setUpLoginButton()
        setUpRegisterButton()
        setUpActivityIndicator()
        setUpBottomImageView()
        
        initConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView(){
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }
    
    func setupContentWrapper(){
        contentWrapper = UIView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentWrapper)
    }
    
    func setupLogoImageView() {
        logoImageView = UIImageView(image: UIImage(named: "LogoImage"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(logoImageView)
    }
    
    func setUpTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
    }
    
    func setUpNameTextField() {
        nameText = UITextField()
        nameText.placeholder = "Name"
        nameText.borderStyle = .roundedRect
        nameText.autocapitalizationType = .none
        nameText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(nameText)
    }
    
    func setUpEmailTextField() {
        emailText = UITextField()
        emailText.placeholder = "Email"
        emailText.borderStyle = .roundedRect
        emailText.autocapitalizationType = .none
        emailText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailText)
    }
    
    func setUpPasswordTextField() {
        passwordText = UITextField()
        passwordText.placeholder = "Password"
        passwordText.borderStyle = .roundedRect
        passwordText.isSecureTextEntry = true
        passwordText.autocapitalizationType = .none
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordText)
    }
    
    func setUpConfirmPasswordTextField() {
        confirmPasswordText = UITextField()
        confirmPasswordText.placeholder = "Confirm Password"
        confirmPasswordText.borderStyle = .roundedRect
        confirmPasswordText.isSecureTextEntry = true
        confirmPasswordText.autocapitalizationType = .none
        confirmPasswordText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(confirmPasswordText)
    }
    
    func setUpRegisterButton() {
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .black
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
    }
    
//    func setUpLoginButton(){
//        loginButton = UIButton(type: .system)
//        loginButton.setTitle("Already have an account? Login!", for: .normal)
//        loginButton.translatesAutoresizingMaskIntoConstraints = false
//        contentWrapper.addSubview(loginButton)
//    }
    
    func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(activityIndicator)
    }
    
    func setUpBottomImageView() {
        bottomImageView = UIImageView()
        bottomImageView.image = UIImage(named: "Signup")
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomImageView)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
                    
            contentWrapper.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 20),
          //  logoImageView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            logoImageView.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
                    
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
                    
            nameText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameText.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            nameText.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            nameText.heightAnchor.constraint(equalToConstant: 44),
                    
            emailText.topAnchor.constraint(equalTo: nameText.bottomAnchor, constant: 16),
            emailText.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            emailText.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            emailText.heightAnchor.constraint(equalToConstant: 44),
                    
            passwordText.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 16),
            passwordText.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            passwordText.trailingAnchor.constraint(equalTo: emailText.trailingAnchor),
            passwordText.heightAnchor.constraint(equalToConstant: 44),
                    
            confirmPasswordText.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 16),
            confirmPasswordText.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            confirmPasswordText.trailingAnchor.constraint(equalTo: emailText.trailingAnchor),
            confirmPasswordText.heightAnchor.constraint(equalToConstant: 44),
                    
            registerButton.topAnchor.constraint(equalTo: confirmPasswordText.bottomAnchor, constant: 24),
            registerButton.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: emailText.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
                    
//            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
//            loginButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
//            loginButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20),
            
            contentWrapper.bottomAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
                    
            activityIndicator.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor, constant: 30),
            
            bottomImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bottomImageView.widthAnchor.constraint(equalToConstant: 450),
            bottomImageView.heightAnchor.constraint(equalToConstant: 145)
        ])
    }



}
