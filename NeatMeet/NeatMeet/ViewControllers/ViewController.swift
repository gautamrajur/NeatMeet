//
//  ViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/21/24.
//

import FirebaseFirestore
import UIKit

class ViewController: UIViewController {

    let landingView = LandingView()
    var navController: UINavigationController?
    var selectedState: String = "Massachusetts"
    var selectedCity: String = "Boston"
    var displayedEvents: [Event] = []
    var events: [Event] = []
    let db = Firestore.firestore()

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

        handleLogin()
        addNotificationCenter()
        configureButtonActions()
        configureUIElements()
        Task { await getAllEvents() }
    }

    private func handleLogin() {
        if TokenManager.shared.token == nil {
            print("calling logging screen")
            showLoginScreen()
        } else {
            getEvents()
        }
    }

    private func configureUIElements() {
        landingView.profileImage.menu = getProfileImageMenu()
        landingView.eventTableView.delegate = self
        landingView.eventTableView.dataSource = self
        landingView.eventTableView.separatorStyle = .none
        landingView.searchBar.delegate = self

        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }

    private func configureButtonActions() {
        landingView.addButton.addTarget(
            self, action: #selector(navigateToCreatePost), for: .touchUpInside)
        landingView.stateButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        landingView.stateDropButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        landingView.cityButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)
        landingView.cityDropButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)
    }

    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleStateSelected(notification:)),
            name: .selectState, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleCitySelected(notification:)),
            name: .selectCity, object: nil)
    }

    func getEvents() {
        for i in 15..<25 {
            let event = Event(
                id: String(i),
                name: "Charles River \(i)",
                likesCount: Int.random(in: 10...100),
                datePublished: Date().addingTimeInterval(
                    TimeInterval(i * -50000)),
                publishedBy: "summer@gmail.com",
                address: "123 Longwood Ave \(i)",
                city: "City \(i)",
                state: "State \(i % 5)",
                imageUrl: "https://example.com/image\(i).jpg"
            )

            events.append(event)
        }
        displayedEvents = events
    }

    func getAllEvents() async {
        let docRef = db.collection("events").order(
            by: "datePublished", descending: false)
        do {
            let snapshot = try await docRef.getDocuments()
            events.removeAll()
            for document in snapshot.documents {
                let data = document.data()
                if let name = data["name"] as? String,
                    let likesCount = data["likesCount"] as? Int,
                    let timestamp = data["datePublished"] as? Timestamp,
                    let address = data["address"] as? String,
                    let city = data["city"] as? String,
                    let state = data["state"] as? String,
                    let imageUrl = data["imageUrl"] as? String,
                    let publishedBy = data["publishedBy"] as? String
                {
                    events.append(
                        Event(
                            id: document.documentID,
                            name: name,
                            likesCount: likesCount,
                            datePublished: timestamp.dateValue(),
                            publishedBy: publishedBy,
                            address: address,
                            city: city,
                            state: state,
                            imageUrl: imageUrl
                        )
                    )
                }
            }
            displayedEvents = events
            landingView.eventTableView.reloadData()

        } catch {
            print("Error getting documents: \(error)")
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
            filterEvents()
        }
    }

    @objc private func handleCitySelected(notification: Notification) {
        let city = (notification.object as! String)
        selectedCity = city
        landingView.cityButton.setTitle(selectedCity, for: .normal)
        filterEvents()
    }

    private func filterEvents() {

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
