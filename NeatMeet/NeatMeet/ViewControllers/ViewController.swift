//
//  ViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/21/24.
//

import UIKit

class ViewController: UIViewController {

    let landingView = LandingView()
    var navController: UINavigationController?
    var selectedState: String = "Massachusetts"
    var selectedCity: String = "Boston"
    var events: [Event] = []

    let states = ["Massachusetts", "California", "New York"]
    let citiesByState = [
        "Massachusetts": ["Boston", "Cambridge", "Springfield"],
        "California": ["Los Angeles", "San Francisco", "San Diego"],
        "New York": ["New York City", "Buffalo", "Rochester"],
    ]

    override func loadView() {
        view = landingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if TokenManager.shared.token == nil {
            print("calling logging screen")
            showLoginScreen()
        } else {
            getEvents()
        }

        landingView.addButton.addTarget(
            self, action: #selector(navigateToCreatePost), for: .touchUpInside)

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleStateSelected(notification:)),
            name: .selectState, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleCitySelected(notification:)),
            name: .selectCity, object: nil)

        landingView.stateButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        landingView.stateDropButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        landingView.cityButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)
        landingView.cityDropButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)

        landingView.profileImage.menu = getProfileImageMenu()

        landingView.eventTableView.delegate = self
        landingView.eventTableView.dataSource = self
        landingView.eventTableView.separatorStyle = .none

        getEvents()

    }

    func getEvents() {
        for i in 15..<25 {
            events.append(
                Event(
                    id: "\(i)", name: "Charles River \(i)",
                    location: "504 Stephen St.",
                    dateTime: "12 Nov - 3:15 PM",
                    image: UIImage(named: "RiverCleaning"), likeCount: 125))
        }
    }

    @objc func navigateToCreatePost() {
        let createPostViewController = CreatePostViewController()
        navigationController?.pushViewController(
            createPostViewController, animated: true)
    }

    func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    func getProfileImageMenu() -> UIMenu {
        let menuItems = [
            UIAction(
                title: "Profile",
                handler: { (_) in self.profileImageTapped() }),
            UIAction(
                title: "Logout",
                handler: { (_) in self.logout() }),
        ]
        return UIMenu(title: "", children: menuItems)
    }

    func profileImageTapped() {
        let profileController = ProfileViewController()
        profileController.delegate = self
        navigationController?.pushViewController(
            profileController, animated: true)

    }

    func logout() {

    }

    @objc private func handleStateSelected(notification: Notification) {
        let state = (notification.object as! String)
        if state != selectedState {
            selectedState = state
            selectedCity = citiesByState[selectedState]?.first ?? ""
            landingView.stateButton.setTitle(selectedState, for: .normal)
            landingView.cityButton.setTitle(selectedCity, for: .normal)
        }
    }

    @objc private func handleCitySelected(notification: Notification) {
        let city = (notification.object as! String)
        selectedCity = city
        landingView.cityButton.setTitle(selectedCity, for: .normal)
    }

    func setUpBottomPickerSheet(
        options: [String], selectedOption: String?,
        notificationName: NSNotification.Name
    ) {
        let finalSelectedOption = selectedOption ?? options.first ?? ""

        let pickerVC = LandingPagePickerViewController(
            options: options, selectedOption: finalSelectedOption,
            notificationName: notificationName
        )

        navController = UINavigationController(rootViewController: pickerVC)
        navController?.modalPresentationStyle = .pageSheet

        if let bottomPickerSheet = navController?.sheetPresentationController {
            bottomPickerSheet.detents = [.medium()]

            bottomPickerSheet.prefersGrabberVisible = false
            navController?.isModalInPresentation = true
        }
    }

    @objc func stateButtonTapped() {
        setUpBottomPickerSheet(
            options: states, selectedOption: selectedState,
            notificationName: .selectState)
        if let navController = navController {
            present(navController, animated: true)
        }
    }

    @objc func cityButtonTapped() {
        let cities =
            citiesByState[selectedState] ?? citiesByState["Massachusetts"] ?? []
        setUpBottomPickerSheet(
            options: cities, selectedOption: selectedCity,
            notificationName: .selectCity)
        if let navController = navController {
            present(navController, animated: true)
        }
    }
}
