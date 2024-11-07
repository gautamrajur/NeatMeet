//
//  CreatePost.swift
//  NeetMeetPostPage
//
//  Created by Gautam Raju on 10/28/24.
//

import UIKit

class CreatePost: UIView {

    var contentWrapper: UIScrollView!
    var headerLabel: UILabel!
    var eventNameTextField: UITextField!
    var locationTextField: UITextField!
    var dateAndTimeTextField: UITextField!
    var descriptionTextField: UITextView!
    var stateCityTextField: UITextField!
    var placeholderLabel: UILabel!

    var buttonTakePhoto: UIButton!
    var choosePhotoLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setUpScrollView()
        setUpHeaderlabel()
        setUpEventNameTextField()
        setUpLocationTextField()
        setUpDateAndTimeTextField()
        setUpDescriptionTextField()
        setUpStateAndCityTextField()
        setupbuttonTakePhoto()
        setUpChoosePhoto()

        initConstraints()
    }

    func setUpScrollView() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }

    func setupbuttonTakePhoto() {
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFit
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonTakePhoto)
    }

    func setUpHeaderlabel() {
        headerLabel = UILabel()
        headerLabel.text = "Create a Post"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(headerLabel)
    }

    func setUpChoosePhoto() {
        choosePhotoLabel = UILabel()
        choosePhotoLabel.text = "Choose a Photo"
        choosePhotoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        choosePhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(choosePhotoLabel)
    }

    func setUpEventNameTextField() {
        eventNameTextField = UITextField()
        eventNameTextField.borderStyle = .roundedRect
        eventNameTextField.placeholder = "Event Name"
        eventNameTextField.autocapitalizationType = .none
        eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(eventNameTextField)
    }

    func setUpLocationTextField() {
        locationTextField = UITextField()
        locationTextField.borderStyle = .roundedRect
        locationTextField.placeholder = "Where Exactly?"
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(locationTextField)
    }

    func setUpDateAndTimeTextField() {
        dateAndTimeTextField = UITextField()
        dateAndTimeTextField.borderStyle = .roundedRect
        dateAndTimeTextField.placeholder = "What time?"
        dateAndTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(dateAndTimeTextField)
    }

    //    func setUpDescriptionTextField() {
    //        descriptionTextField = UITextView()
    //
    //        descriptionTextField.frame = CGRect(x: 20, y: 100, width: 300, height: 200)
    //        descriptionTextField.font = UIFont.systemFont(ofSize: 18)
    //        descriptionTextField.isEditable = true
    ////        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
    ////        descriptionTextField.layer.borderWidth = 1.0
    ////        descriptionTextField.layer.cornerRadius = 8.0
    ////
    ////        descriptionTextField.text = "Description"
    ////        descriptionTextField.textColor = .lightGray
    //
    //        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
    //        contentWrapper.addSubview(descriptionTextField)
    //    }

    func setUpDescriptionTextField() {
        descriptionTextField = UITextView()
        descriptionTextField.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.cornerRadius = 8.0
        descriptionTextField.font = UIFont.systemFont(ofSize: 16)
        descriptionTextField.textColor = .black
        descriptionTextField.isScrollEnabled = true
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.delegate = self

        // Create the placeholder label
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your note here..."
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        contentWrapper.addSubview(descriptionTextField)
        contentWrapper.addSubview(placeholderLabel)
    }

    func setUpStateAndCityTextField() {
        stateCityTextField = UITextField()
        stateCityTextField.borderStyle = .roundedRect
        stateCityTextField.placeholder = "State and City"
        stateCityTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(stateCityTextField)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.heightAnchor),

            headerLabel.topAnchor.constraint(
                equalTo: contentWrapper.topAnchor, constant: 16),
            headerLabel.centerXAnchor.constraint(
                equalTo: contentWrapper.centerXAnchor),

            eventNameTextField.topAnchor.constraint(
                equalTo: headerLabel.bottomAnchor, constant: 32),
            eventNameTextField.leadingAnchor.constraint(
                equalTo: contentWrapper.leadingAnchor, constant: 20),
            eventNameTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventNameTextField.heightAnchor.constraint(equalToConstant: 44),

            locationTextField.topAnchor.constraint(
                equalTo: eventNameTextField.bottomAnchor, constant: 32),
            locationTextField.leadingAnchor.constraint(
                equalTo: contentWrapper.leadingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            dateAndTimeTextField.topAnchor.constraint(
                equalTo: locationTextField.bottomAnchor, constant: 32),
            dateAndTimeTextField.leadingAnchor.constraint(
                equalTo: contentWrapper.leadingAnchor, constant: 20),
            dateAndTimeTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            descriptionTextField.topAnchor.constraint(
                equalTo: dateAndTimeTextField.bottomAnchor, constant: 32),
            descriptionTextField.leadingAnchor.constraint(
                equalTo: contentWrapper.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 100),

            placeholderLabel.topAnchor.constraint(
                equalTo: descriptionTextField.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: descriptionTextField.leadingAnchor, constant: 5),

            stateCityTextField.topAnchor.constraint(
                equalTo: descriptionTextField.bottomAnchor, constant: 32),
            stateCityTextField.leadingAnchor.constraint(
                equalTo: contentWrapper.leadingAnchor, constant: 20),
            stateCityTextField.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stateCityTextField.bottomAnchor.constraint(
                equalTo: contentWrapper.bottomAnchor, constant: -32),

            buttonTakePhoto.topAnchor.constraint(
                equalTo: stateCityTextField.bottomAnchor, constant: 32),
            buttonTakePhoto.centerXAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 150),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 150),

            choosePhotoLabel.topAnchor.constraint(
                equalTo: buttonTakePhoto.bottomAnchor, constant: 16),
            choosePhotoLabel.centerXAnchor.constraint(
                equalTo: contentWrapper.centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !descriptionTextField.text.isEmpty
    }
}

extension CreatePost: UITextViewDelegate {
    func textViewDidChange(_ descriptionTextField: UITextView) {
        updatePlaceholderVisibility()
    }
}
