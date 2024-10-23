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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setUpProfileImage()
        setUpSearchBar()

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

    private func initConstraints() {
        NSLayoutConstraint.activate([

            // profile Image
            profileImage.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            profileImage.widthAnchor.constraint(equalToConstant: 40),
            profileImage.heightAnchor.constraint(equalToConstant: 40),

            // search Bar
            searchBar.leadingAnchor.constraint(
                equalTo: profileImage.trailingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -16),
            searchBar.centerYAnchor.constraint(
                equalTo: profileImage.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
