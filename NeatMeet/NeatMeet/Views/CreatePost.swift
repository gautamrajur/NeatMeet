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
    var timePicker: UIDatePicker!
    var descriptionTextField: UITextView!
    var stateCityTextField: UITextField!
    var placeholderLabel: UILabel!
    
    
    var stateButton: UIButton!
    var cityButton: UIButton!
    var cityDropButton: UIButton!
    var stateDropButton: UIButton!
    var saveButton: UIButton!
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
        setUpStatePicker()
        setUpCityPicker()
        setUpSaveButton()
        setupbuttonTakePhoto()
        setUpChoosePhoto()
        
        initConstraints()
    }
    
    func setUpScrollView() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setUpSaveButton(){
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
    }

    func setupbuttonTakePhoto() {
        buttonTakePhoto = UIButton(type: .custom)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.setImage(UIImage(named: "event_placeholder"), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFit
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonTakePhoto)
    }

    func setUpHeaderlabel() {
        headerLabel = UILabel()
        headerLabel.text = "Create an Event"
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
        eventNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        eventNameTextField.layer.borderWidth = 1.0
        eventNameTextField.layer.cornerRadius = 8.0
        eventNameTextField.font = UIFont.systemFont(ofSize: 16)
        eventNameTextField.textColor = .black
        eventNameTextField.placeholder = "Event Name"
        eventNameTextField.autocapitalizationType = .none
        eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(eventNameTextField)
    }

    func setUpLocationTextField() {
        locationTextField = UITextField()
        locationTextField.borderStyle = .roundedRect
        locationTextField.layer.borderColor = UIColor.lightGray.cgColor
        locationTextField.layer.borderWidth = 1.0
        locationTextField.layer.cornerRadius = 8.0
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        locationTextField.textColor = .black
        locationTextField.placeholder = "Where Exactly?"
        eventNameTextField.autocapitalizationType = .none
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(locationTextField)
    }

    func setUpDateAndTimeTextField() {
        
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .dateAndTime
        timePicker.preferredDatePickerStyle = .compact // Use wheels for a classic look
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Optional: Set locale or 24-hour format
        timePicker.locale = Locale(identifier: "en_US") // Adjust for desired locale
        timePicker.calendar = Calendar.current
        timePicker.minuteInterval = 1 // Set minute intervals (e.g., 1, 5, 15)
        
        contentWrapper.addSubview(timePicker)

    }

    private func setUpStatePicker() {
        stateButton = UIButton(type: .system)
        stateButton.setTitle("Massachusetts", for: .normal)
        stateButton.tintColor = .black
        stateButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(stateButton) // Fix here

        stateDropButton = UIButton(type: .system)
        let stateDropImage = UIImage(systemName: "chevron.down")
        stateDropButton.setImage(stateDropImage, for: .normal)
        stateDropButton.tintColor = .black
        stateDropButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(stateDropButton) // Fix here
    }


    private func setUpCityPicker() {
        cityButton = UIButton(type: .system)
        cityButton.setTitle("Boston", for: .normal)
        cityButton.tintColor = .black
        cityButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(cityButton) // Fix here

        cityDropButton = UIButton(type: .system)
        let cityDropImage = UIImage(systemName: "chevron.down")
        cityDropButton.setImage(cityDropImage, for: .normal)
        cityDropButton.tintColor = .black
        cityDropButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(cityDropButton) // Fix here
    }

    func setUpDescriptionTextField() {
        descriptionTextField = UITextView()
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
        placeholderLabel.text = "Tell us more about it..."
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
            // Content Wrapper
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            // Header Label
            headerLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 16),
            headerLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            // Event Name TextField
            eventNameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 32),
            eventNameTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            eventNameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            // Location TextField
            locationTextField.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor, constant: 32),
            locationTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            // State Button
            stateButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 32),
            stateButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            // State Dropdown Button
            stateDropButton.leadingAnchor.constraint(equalTo: stateButton.trailingAnchor, constant: 8),
            stateDropButton.centerYAnchor.constraint(equalTo: stateButton.centerYAnchor),
            stateDropButton.widthAnchor.constraint(equalToConstant: 18),
            stateDropButton.heightAnchor.constraint(equalToConstant: 18),

            // City Button
            cityButton.topAnchor.constraint(equalTo: stateButton.bottomAnchor, constant: 16),
            cityButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            // City Dropdown Button
            cityDropButton.leadingAnchor.constraint(equalTo: cityButton.trailingAnchor, constant: 8),
            cityDropButton.centerYAnchor.constraint(equalTo: cityButton.centerYAnchor),
            cityDropButton.widthAnchor.constraint(equalToConstant: 18),
            cityDropButton.heightAnchor.constraint(equalToConstant: 18),

            // Description TextField
            descriptionTextField.topAnchor.constraint(equalTo: cityButton.bottomAnchor, constant: 32),
            descriptionTextField.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 100),

            // Placeholder Label
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextField.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextField.leadingAnchor, constant: 5),

            // Time Picker
            timePicker.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 32),
            timePicker.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            // Take Photo Button
            buttonTakePhoto.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 32),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 150),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 150),

            // Choose Photo Label
            choosePhotoLabel.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 16),
            choosePhotoLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            choosePhotoLabel.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -20)
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
