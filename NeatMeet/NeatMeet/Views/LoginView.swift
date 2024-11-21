//
//  LoginView.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 10/31/24.
//

import UIKit

class LoginView: UIView {

    var scrollView: UIScrollView!
    var contentWrapper: UIView!
    var logoImageView: UIImageView!
    var titleLabel: UILabel!
    var emailText: UITextField!
    var passwordText: UITextField!
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
        setUpEmailTextField()
        setUpPasswordTextField()
        setUpLoginButton()
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
        titleLabel.text = "Login"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
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
    
    func setUpLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .black
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginButton)
    }
    
    func setUpRegisterButton(){
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Don't have an account? Register!", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
    }
    
    func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(activityIndicator)
    }
    
    func setUpBottomImageView() {
        bottomImageView = UIImageView()
        bottomImageView.image = UIImage(named: "LoginSketch")
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomImageView)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
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
            
            emailText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailText.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            emailText.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            emailText.heightAnchor.constraint(equalToConstant: 44),
            
            passwordText.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 16),
            passwordText.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            passwordText.trailingAnchor.constraint(equalTo: emailText.trailingAnchor),
            passwordText.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: emailText.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailText.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor, constant: 30),
            
            bottomImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bottomImageView.widthAnchor.constraint(equalToConstant: 400),
            bottomImageView.heightAnchor.constraint(equalToConstant: 250)
            
        ])
    }


}
