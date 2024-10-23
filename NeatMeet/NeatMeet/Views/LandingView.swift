//
//  LandingView.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/22/24.
//

import UIKit

class LandingView: UIView {

    var profileImage: UIImageView!
    var searchBar: UISearchBar!
    var stateButton: UIButton!
    var cityButton: UIButton!
    var statePicker: UIPickerView!
    var cityPicker: UIPickerView!
    var cityDropButton: UIButton!
    var stateDropButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpProfileImage()
        setUpSearchBar()
        setUpStatePicker()
        setUpCityPicker()

        initConstraints()
    }

    private func setUpProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.fill")
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 20
        profileImage.tintColor = .gray
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImage)
    }

    private func setUpSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Events"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.clipsToBounds = true

        addSubview(searchBar)
    }

    private func setUpStatePicker() {
        stateButton = UIButton(type: .system)
        stateButton.setTitle("Massachusetts", for: .normal)
        stateButton.tintColor = .black
        stateButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateButton)

        stateDropButton = UIButton(type: .system)
        let stateDropImage = UIImage(systemName: "chevron.down")
        stateDropButton.setImage(stateDropImage, for: .normal)
        stateDropButton.tintColor = .black
        stateDropButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stateDropButton)

        statePicker = UIPickerView()
        statePicker.translatesAutoresizingMaskIntoConstraints = false
        statePicker.isHidden = true
        addSubview(statePicker)
    }

    private func setUpCityPicker() {
        cityButton = UIButton(type: .system)
        cityButton.setTitle("Boston", for: .normal)
        cityButton.tintColor = .black
        cityButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cityButton)
        
        cityDropButton = UIButton(type: .system)
        let cityDropImage = UIImage(systemName: "chevron.down")
        cityDropButton.setImage(cityDropImage, for: .normal)
        cityDropButton.tintColor = .black
        cityDropButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cityDropButton)
        
        cityPicker = UIPickerView()
        cityPicker.translatesAutoresizingMaskIntoConstraints = false
        cityPicker.isHidden = true
        addSubview(cityPicker)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            // Profile Image
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileImage.widthAnchor.constraint(equalToConstant: 40),
            profileImage.heightAnchor.constraint(equalToConstant: 40),

            // Search Bar
            searchBar.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBar.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),

            // City Drop Button
            cityDropButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            cityDropButton.centerYAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            cityDropButton.widthAnchor.constraint(equalToConstant: 18),
            cityDropButton.heightAnchor.constraint(equalToConstant: 18),

            // City Button
            cityButton.trailingAnchor.constraint(equalTo: cityDropButton.leadingAnchor, constant: -4),
            cityButton.centerYAnchor.constraint(equalTo: cityDropButton.centerYAnchor),

            // State Drop Button
            stateDropButton.trailingAnchor.constraint(equalTo: cityButton.leadingAnchor, constant: -16),
            stateDropButton.centerYAnchor.constraint(equalTo: cityDropButton.centerYAnchor),
            stateDropButton.widthAnchor.constraint(equalToConstant: 18),
            stateDropButton.heightAnchor.constraint(equalToConstant: 18),

            // State Button
            stateButton.trailingAnchor.constraint(equalTo: stateDropButton.leadingAnchor, constant: -4),
            stateButton.centerYAnchor.constraint(equalTo: stateDropButton.centerYAnchor),

            // State Picker
            statePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            statePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            statePicker.topAnchor.constraint(equalTo: stateButton.bottomAnchor, constant: 8),
            statePicker.heightAnchor.constraint(equalToConstant: 200),

            // City Picker
            cityPicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cityPicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cityPicker.topAnchor.constraint(equalTo: cityButton.bottomAnchor, constant: 8),
            cityPicker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
