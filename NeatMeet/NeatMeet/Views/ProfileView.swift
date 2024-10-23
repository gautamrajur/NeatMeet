//
//  ProfileView.swift
//  NeatMeet
//
//  Created by Saniya Anklesaria on 10/22/24.
//
import UIKit

class ProfileView: UIView {

    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var buttonSave: UIButton!
    var imageContacts: UIImageView!
    var editButtonFrame: UIView!
    var editButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfileImage()
        setupFieldName()
        setupFieldEmail()
        setUpButtonSave()
        setUpEditButtonFrame()
        setupEditButton()
        
        initConstraints()
    }

    // Change imageContacts to UIImageView
    func setupProfileImage() {
        imageContacts = UIImageView()
        imageContacts.image = UIImage(systemName: "person.fill")
        imageContacts.tintColor = .darkGray
        imageContacts.layer.cornerRadius = 50
        imageContacts.layer.borderWidth = 1
        imageContacts.layer.borderColor = UIColor.lightGray.cgColor
        imageContacts.contentMode = .scaleAspectFill
        imageContacts.clipsToBounds = true
        imageContacts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageContacts)
    }
    
    func setUpEditButtonFrame(){
        editButtonFrame = UIView()
        editButtonFrame.backgroundColor = .lightGray
        editButtonFrame.layer.cornerRadius = 15
        editButtonFrame.clipsToBounds = true
        editButtonFrame.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(editButtonFrame)
    }

    func setupEditButton() {
        editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        editButton.tintColor = .black
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.showsMenuAsPrimaryAction = true
        editButton.clipsToBounds = true
        self.addSubview(editButton)
    }

    func setUpButtonSave() {
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.setTitleColor(.black, for: .normal)
        buttonSave.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonSave.layer.borderColor = UIColor.black.cgColor
        buttonSave.backgroundColor = .lightGray
        buttonSave.layer.borderWidth = 1.0
        buttonSave.layer.cornerRadius = 10.0
        buttonSave.clipsToBounds = true
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSave)
    }

    func setupFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.font = UIFont.systemFont(ofSize: 16)
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldName)
    }

    func setupFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.font = UIFont.systemFont(ofSize: 16)
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldEmail)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            imageContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            imageContacts.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageContacts.heightAnchor.constraint(equalToConstant: 100),
            imageContacts.widthAnchor.constraint(equalTo: imageContacts.heightAnchor),
            
            editButtonFrame.bottomAnchor.constraint(equalTo: imageContacts.bottomAnchor, constant: 0),
            editButtonFrame.trailingAnchor.constraint(equalTo: imageContacts.trailingAnchor, constant: 0),
            editButtonFrame.heightAnchor.constraint(equalToConstant: 30),
            editButtonFrame.widthAnchor.constraint(equalToConstant: 30),

            editButton.centerXAnchor.constraint(equalTo: editButtonFrame.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: editButtonFrame.centerYAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 18),
            editButton.widthAnchor.constraint(equalToConstant: 24),

            textFieldName.topAnchor.constraint(equalTo: imageContacts.topAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: imageContacts.trailingAnchor, constant: 10),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            textFieldName.heightAnchor.constraint(equalToConstant: 30),

            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 8),
            textFieldEmail.leadingAnchor.constraint(equalTo: imageContacts.trailingAnchor, constant: 10),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 30),

            buttonSave.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonSave.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 10),
            buttonSave.heightAnchor.constraint(equalToConstant: 20),
            buttonSave.widthAnchor.constraint(equalToConstant: 70),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
