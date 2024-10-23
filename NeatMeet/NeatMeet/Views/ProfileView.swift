//
//  ProfileView.swift
//  NeatMeet
//
//  Created by Saniya Anklesaria on 10/22/24.
//
import UIKit

class ProfileView: UIView {

       
        var textFieldName: UITextField!
        var textFieldEmail:UITextField!
        var buttonSave:UIButton!
        var imageContacts: UIButton!
        var photoLabel: UILabel!
        
        
        //MARK: View initializer...
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = .white
            
            
            //setupWrapperCellView()
            setupProfileImage()
            setupFieldName()
            setupFieldEmail()
            setUpButtonSave()
            //setupbuttonTakePhoto()
            
            initConstraints()
            
        }
        
    
    func setupProfileImage(){
        imageContacts = UIButton(type: .system)
        imageContacts.setTitle("", for: .normal)
        imageContacts.tintColor = .black
        imageContacts.setImage(UIImage(systemName: "person.fill"), for: .normal)
        imageContacts.contentHorizontalAlignment = .fill
        imageContacts.contentVerticalAlignment = .fill
        imageContacts.imageView?.contentMode = .scaleAspectFit
        imageContacts.showsMenuAsPrimaryAction = true
        imageContacts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageContacts)
    }
    
//    func setupbuttonTakePhoto(){
//        photoLabel = UILabel()
//        photoLabel.text="Photo"
//        photoLabel.textColor = .lightGray
//        photoLabel.font = UIFont.systemFont(ofSize: 14)
//        photoLabel.translatesAutoresizingMaskIntoConstraints=false
//        self.addSubview(photoLabel)
//    }
//    
    func setUpButtonSave(){
        buttonSave = UIButton(type: .system)
        buttonSave.setTitle("", for: .normal)
        buttonSave.setTitleColor(.black, for: .normal)
        buttonSave.setTitle("Save", for: .normal)
        buttonSave.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonSave.showsMenuAsPrimaryAction = true
        buttonSave.layer.borderColor = UIColor.black.cgColor
        buttonSave.backgroundColor = .lightGray
        buttonSave.layer.borderWidth = 1.0
        buttonSave.layer.cornerRadius = 10.0
        buttonSave.clipsToBounds = true
        buttonSave.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSave)
    }
    
    
        func setupFieldName(){
            textFieldName=UITextField()
            textFieldName.placeholder="Name"
            textFieldName.borderStyle = .roundedRect
            textFieldName.font=UIFont.systemFont(ofSize:16)
            textFieldName.translatesAutoresizingMaskIntoConstraints=false
            self.addSubview(textFieldName)
        }
        
        
        func setupFieldEmail(){
            textFieldEmail=UITextField()
            textFieldEmail.placeholder="Email"
            textFieldEmail.borderStyle = .roundedRect
            textFieldEmail.font=UIFont.systemFont(ofSize:16)
            textFieldEmail.keyboardType = .emailAddress
            textFieldEmail.translatesAutoresizingMaskIntoConstraints=false
            self.addSubview(textFieldEmail)
        }
        
        
        
        //MARK: initializing the constraints...
        func initConstraints(){
            NSLayoutConstraint.activate([
                imageContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                imageContacts.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20), // Changed from centerYAnchor to topAnchor
                imageContacts.heightAnchor.constraint(equalToConstant: 100),
                imageContacts.widthAnchor.constraint(equalTo: imageContacts.heightAnchor),

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
                
                
//                photoLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
//                photoLabel.topAnchor.constraint(equalTo: imageContacts.bottomAnchor, constant: 1),
            ])

            }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }


