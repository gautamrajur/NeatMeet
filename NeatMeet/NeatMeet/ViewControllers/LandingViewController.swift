//
//  LandingViewController.swift
//  NeatMeet
//
//  Created by Esha Chiplunkar on 11/21/24.
//

import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import UIKit

class LandingViewController: UIViewController {

    let landingView = LandingView()
    var navController: UINavigationController?
    var selectedState: State = State(name: "", isoCode: "")
    var selectedCity: City = City(name: "", stateCode: "")
    var displayedEvents: [Event] = []
    var events: [Event] = []
    let db = Firestore.firestore()
    let locationAPI = LocationAPI()
    var citiesList: [City] = []
    var statesList: [State] = []
    var refreshTimer: Timer?
    
    override func loadView() {
        view = landingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        addNotificationCenter()
        configureButtonActions()
        configureUIElements()
        addEditNotiifcationObservor()
        requestLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await setUpProfileData()
        }
    }

    private func requestLocation() {
        LocationManager.shared.getCurrentLocation { [weak self] result in
            guard let self = self else { return }

            Task {
                // Get all states first
                self.statesList = await self.locationAPI.getAllStates()

                if let (detectedStateCode, detectedCity) = result {
                    // Find matching state in statesList using the ISO code
                    if let matchingState = self.statesList.first(where: {
                        $0.isoCode == detectedStateCode
                    }) {
                        self.selectedState = matchingState
                        // Get cities for the detected state
                        self.citiesList = await self.locationAPI.getAllCities(
                            stateCode: matchingState.isoCode)

                        // Find matching city
                        if let matchingCity = self.citiesList.first(where: {
                            $0.name.lowercased() == detectedCity.lowercased()
                        }) {
                            self.selectedCity = matchingCity
                        } else {
                            self.selectedCity =
                                self.citiesList.first
                                ?? City(name: "", stateCode: "")
                        }
                    } else {
                        // Fallback to first state and city if no match found
                        await self.initStateAndCity()
                    }
                } else {
                    // Fallback to first state and city if location detection failed
                    await self.initStateAndCity()
                }

                // Update UI on main thread
                DispatchQueue.main.async {
                    self.landingView.stateButton.setTitle(
                        self.selectedState.name, for: .normal)
                    self.landingView.cityButton.setTitle(
                        self.selectedCity.name, for: .normal)
                }

                // Fetch events for the selected location
                await self.getAllEvents()
            }
        }
    }

    private func setUpProfileData() async {
        do {
            guard let userIdString = UserManager.shared.loggedInUser?.id else {
                print("No logged-in user ID found.")
                return
            }

            let snapshot = try await db.collection("users").document(
                userIdString
            ).getDocument()

            guard let data = snapshot.data() else {
                print("No user found with the given ID.")
                return
            }

            if let imageUrl = data["imageUrl"] as? String {
                if let imageUrlURL = URL(string: imageUrl) {
                    landingView.profileImage.sd_setImage(
                        with: imageUrlURL,
                        for: .normal,
                        placeholderImage: UIImage(systemName: "person.fill")
                    )
                }
                UserManager.shared.loggedInUser?.imageUrl = imageUrl

            } else {
                print("Invalid user data format.")
            }
        } catch {
            print(
                "Error fetching user data from Firestore: \(error.localizedDescription)"
            )
        }
    }

    private func initStateAndCity() async {
        statesList = await locationAPI.getAllStates()
        if statesList.count > 0 {
            selectedState = statesList.first!
            landingView.stateButton.setTitle(
                selectedState.name, for: .normal)
            citiesList = await locationAPI.getAllCities(
                stateCode: selectedState.isoCode)
            selectedCity = citiesList.first!
            landingView.cityButton.setTitle(
                selectedCity.name, for: .normal)
            await getAllEvents()
        }
    }

    private func configureUIElements() {
        landingView.profileImage.menu = getProfileImageMenu()
        landingView.eventTableView.delegate = self
        landingView.eventTableView.dataSource = self
        landingView.eventTableView.separatorStyle = .none
        landingView.searchBar.delegate = self
        landingView.refreshControl.addTarget(
            self, action: #selector(refreshData(_:)), for: .valueChanged)
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        tapRecognizer.cancelsTouchesInView = false
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }
    
    @objc func refreshData(_ sender: Any) {
        Task {
            await getAllEvents()
            landingView.refreshControl.endRefreshing()
        }
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
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchEvents(notification:)),
            name: .newEventAdded, object: nil)
    }

    func getAllEvents() async {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let docRef = db.collection("events")
            .whereField("state", isEqualTo: selectedState.name)
            .whereField("city", isEqualTo: selectedCity.name)
            .whereField("eventDate", isGreaterThanOrEqualTo: currentDate)
            .order(by: "eventDate", descending: false)
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
                    let publishedBy = data["publishedBy"] as? String,
                    let eventDate = data["eventDate"] as? Timestamp,
                    let eDetails = data["eventDescription"] as? String
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
                            imageUrl: imageUrl,
                            eventDate: eventDate.dateValue(),
                            eventDescription: eDetails
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

    @objc func fetchEvents(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let state = userInfo["state"] as? State,
            let city = userInfo["city"] as? City
        else {
            return
        }
        if state.isoCode == selectedState.isoCode
            && city.name == selectedCity.name
        {
            Task {
                await getAllEvents()
            }
        }
    }

    @objc func navigateToCreatePost() {
        let createPostViewController = CreatePostViewController()
        navigationController?.pushViewController(
            createPostViewController, animated: true)
    }

    func showLoginScreen() {
        let loginVC = LoginViewController()
        navigationController?.setViewControllers([loginVC], animated: true)
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
        let logoutAlert = UIAlertController(
            title: "Logging out!", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(
            UIAlertAction(
                title: "Yes, log out!", style: .default,
                handler: { (_) in
                    do {
                        try Auth.auth().signOut()
                        print(
                            "current user: ",
                            Auth.auth().currentUser ?? "no user")
                        print("Logged out, proceeding to call login screen")
                        self.showLoginScreen()
                    } catch {
                        print("Error occured!")
                    }
                })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(logoutAlert, animated: true)
    }

    @objc private func handleStateSelected(notification: Notification) {
        let state = (notification.object as! State)
        if state.isoCode != selectedState.isoCode {
            selectedState = state
            landingView.stateButton.setTitle(selectedState.name, for: .normal)
            Task {
                citiesList = await locationAPI.getAllCities(
                    stateCode: state.isoCode)
                if !citiesList.isEmpty {
                    selectedCity = citiesList.first!
                    landingView.cityButton.setTitle(
                        selectedCity.name, for: .normal)
                } else {
                    citiesList = []
                    selectedCity = City(name: "", stateCode: "")
                    landingView.cityButton.setTitle(
                        selectedCity.name, for: .normal)
                }
                await getAllEvents()
            }
        }
    }

    @objc private func handleCitySelected(notification: Notification) {
        let city = (notification.object as! City)
        selectedCity = city
        landingView.cityButton.setTitle(selectedCity.name, for: .normal)
        Task {
            await getAllEvents()
        }
    }

    func setUpBottomSearchSheet<T: Searchable>(
        options: [T], selectedOption: T?,
        notificationName: NSNotification.Name
    ) {
        let pickerVC = SearchablePickerViewController<T>(
            options: options,
            selectedOption: selectedOption,
            notificationName: notificationName
        )

        navController = UINavigationController(rootViewController: pickerVC)
        navController?.modalPresentationStyle = .pageSheet

        if let bottomPickerSheet = navController?.sheetPresentationController {
            bottomPickerSheet.detents = [.medium()]
            bottomPickerSheet.prefersGrabberVisible = false
            navController?.isModalInPresentation = true
        }

        if let navController = navController {
            present(navController, animated: true)
        }
    }

    @objc func stateButtonTapped() {
        setUpBottomSearchSheet(
            options: statesList, selectedOption: selectedState,
            notificationName: .selectState)
    }

    @objc func cityButtonTapped() {
        setUpBottomSearchSheet(
            options: citiesList, selectedOption: selectedCity,
            notificationName: .selectCity)
    }
    
    func addEditNotiifcationObservor() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchEvents(notification:)),
            name: .contentEdited, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchEvents(notification:)),
            name: .likeUpdated, object: nil)
    }

    
}
