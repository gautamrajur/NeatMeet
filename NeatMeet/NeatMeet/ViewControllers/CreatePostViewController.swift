//
//  CreatePostViewController.swift
//  NeatMeet
//
//
//  Created by Gautam Raju on 10/28/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import UIKit

class CreatePostViewController: UIViewController {

    var createPost = CreatePost()
    var pickedImage: UIImage?
    var previousImage: UIImage? = UIImage(named: "event_placeholder")

    var currentUser: FirebaseAuth.User?
    let showPost = ShowPostViewController()
    let database = Firestore.firestore()

    var navController: UINavigationController?
    let locationAPI = LocationAPI()
    var citiesList: [City] = []
    var statesList: [State] = []
    var selectedState: State = State(name: "", isoCode: "")
    var prevSelectedState: State?
    var prevSelectedCity: City?
    var selectedCity: City = City(name: "", stateCode: "")
    var eventDetails: Event?
    var eventId: String?
    var isEditingPost: Bool = false

    override func loadView() {
        view = createPost
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if isEditingPost, let eventId = eventId {
            createPost.headerLabel.text = "Update Event"
            self.createPost.placeholderLabel.isHidden = true
            fetchEventDetails(for: eventId)
        }
        
        addSaveButton()
        hideKeyboardOnTapOutside()
        addNotificationCenter()
        createPost.buttonTakePhoto.menu = getMenuImagePicker()
        configureButtonActions()
        if(!isEditingPost) {
            requestLocation()
        }
        

    }

    private func fetchEventDetails(for eventId: String) {
        let db = Firestore.firestore()
        db.collection("events").document(eventId).getDocument {
            [weak self] document, error in
            if let error = error {
                print("Error fetching event")
                return
            }

            guard let document = document, document.exists,
                let event = try? document.data(as: Event.self)
            else {
                print("Failed to decode event data.")
                return
            }

            self?.populateFields(event: event)
            
        }
    }

    private func populateFields(event: Event) {
        eventDetails = event
        createPost.eventNameTextField.text = event.name
        createPost.locationTextField.text = event.address
        createPost.descriptionTextField.text = event.eventDescription
        createPost.timePicker.date = event.eventDate
        
        Task {
            // Get all states first
            self.statesList = await self.locationAPI.getAllStates()
            
            if let matchingState = self.statesList.first(where: {
                $0.name == event.state
            }) {
                selectedState = State(name: matchingState.name, isoCode: matchingState.isoCode)
                prevSelectedState = selectedState
                self.citiesList = await self.locationAPI.getAllCities(
                    stateCode: matchingState.isoCode)
                if let matchingCity = self.citiesList.first(where: {
                    $0.name.lowercased() == event.city.lowercased()
                }) {
                    self.selectedCity = matchingCity
                    prevSelectedCity = selectedCity
                } else {
                    self.selectedCity =
                    self.citiesList.first
                    ?? City(name: "", stateCode: "")
                }
            }
            
            createPost.stateButton.setTitle(selectedState.name, for: .normal)
            createPost.cityButton.setTitle(selectedCity.name, for: .normal)
        }
        if !event.imageUrl.isEmpty {
            loadImage(from: event.imageUrl)
        }
    }

    private func loadImage(from url: String) {
        if let imageUrl = URL(string: url) {
            self.createPost.buttonTakePhoto.sd_setImage(
                with: imageUrl,
                for: .normal,
                placeholderImage: UIImage(named: "event_placeholder"),
                completed: { [weak self] (image, error, _, _) in
                    if let loadedImage = image {
                        self?.pickedImage = loadedImage
                        self?.previousImage = loadedImage
                    }
                }
            )
        } else {
            let placeholderImage = UIImage(named: "event_placeholder")
            self.createPost.buttonTakePhoto.setImage(
                placeholderImage, for: .normal)
            self.pickedImage = placeholderImage
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
                    self.createPost.stateButton.setTitle(
                        self.selectedState.name, for: .normal)
                    self.createPost.cityButton.setTitle(
                        self.selectedCity.name, for: .normal)
                }

            }
        }
    }

    private func initStateAndCity() async {
        statesList = await locationAPI.getAllStates()
        if statesList.count > 0 {
            selectedState = statesList.first!
            createPost.stateButton.setTitle(
                selectedState.name, for: .normal)
            citiesList = await locationAPI.getAllCities(
                stateCode: selectedState.isoCode)
            selectedCity = citiesList.first!
            createPost.cityButton.setTitle(
                selectedCity.name, for: .normal)
        }
    }

    func addSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .save,
                    target: self,
                    action: #selector(onTapPost)
                )
    }

    private func configureButtonActions() {
        createPost.stateButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        createPost.stateDropButton.addTarget(
            self, action: #selector(stateButtonTapped), for: .touchUpInside)
        createPost.cityButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)
        createPost.cityDropButton.addTarget(
            self, action: #selector(cityButtonTapped), for: .touchUpInside)
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
            notificationName: .selectStateCreatePost)
    }

    @objc func cityButtonTapped() {
        setUpBottomSearchSheet(
            options: citiesList, selectedOption: selectedCity,
            notificationName: .selectCityCreatePost)
    }

    // Notification Center
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleStateSelected(notification:)),
            name: .selectStateCreatePost, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleCitySelected(notification:)),
            name: .selectCityCreatePost, object: nil)
    }

    // Notification handlers

    @objc private func handleStateSelected(notification: Notification) {
        let state = (notification.object as! State)
        if state.isoCode != selectedState.isoCode {
            selectedState = state
            createPost.stateButton.setTitle(selectedState.name, for: .normal)
            Task {
                citiesList = await locationAPI.getAllCities(
                    stateCode: state.isoCode)
                if !citiesList.isEmpty {
                    selectedCity = citiesList.first!
                    createPost.cityButton.setTitle(
                        selectedCity.name, for: .normal)
                }
            }
        }
    }

    @objc private func handleCitySelected(notification: Notification) {
        let city = (notification.object as! City)
        selectedCity = city
        createPost.cityButton.setTitle(selectedCity.name, for: .normal)
    }
    
    func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onTapPost() {
        // push to next screen.
        // set all the second screen variables
        guard let eName = createPost.eventNameTextField.text, !eName.isEmpty,
              let eLocation = createPost.locationTextField.text, !eLocation.isEmpty,
              let eDetails = createPost.descriptionTextField.text, !eDetails.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill all required fields."){}
               return
        }
        let eDateTime = createPost.timePicker.date
        let ePhoto = createPost.buttonTakePhoto.imageView?.image

        // Need to upload the image to Firebase Storage and retrieve the URL for it to populate in the db
        if ePhoto != UIImage(named: "event_placeholder") && previousImage != ePhoto{
            var imageUrl: String? = nil
            if let image = ePhoto,
                let imageData = image.jpegData(compressionQuality: 0.8)
            {
                // Upload image to Firebase Storage
                let imageRef = Storage.storage().reference().child(
                    "eventImages/\(UUID().uuidString).jpg")

                imageRef.putData(
                    imageData,
                    completion: { (url, error) in
                        if error == nil {
                            imageRef.downloadURL(completion: { (url, error) in
                                if error == nil {
                                    imageUrl = url?.absoluteString
                                    self.postEventToFirestore(
                                        eventName: eName, location: eLocation,
                                        description: eDetails,
                                        eventDate: eDateTime,
                                        imageUrl: imageUrl, eDetails: eDetails)
                                }
                            })
                        }
                    })
            }
        } else {
            self.postEventToFirestore(
                eventName: eName, location: eLocation, description: eDetails,
                eventDate: eDateTime, imageUrl: eventDetails?.imageUrl, eDetails: eDetails)
        }
    }

    func postEventToFirestore(
        eventName: String, location: String, description: String,
        eventDate: Date, imageUrl: String?, eDetails: String
    ) {
        let db = Firestore.firestore()

        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }

        // Create the event data
        let event = Event(
            name: eventName,
            likesCount: 0,
            datePublished: Date(),
            publishedBy: userId,
            address: location,
            city: selectedCity.name,
            state: selectedState.name,
            imageUrl: imageUrl ?? "",
            eventDate: eventDate,
            eventDescription: eDetails)

        if isEditingPost, let eventId = eventId {
            // Update existing event
            do {
                try db.collection("events").document(eventId).setData(from: event) { error in
                    if error != nil {
                        print("Error updating event to Firestore")
                    } else {
                        print("Event successfully updated in Firestore!")
                        
                        // Remove eventId from the likes collections of all users
                        self.removeEventFromUserLikes(eventId: eventId) {
                            self.showPost.eventId = eventId
                            let data = ["state": self.selectedState, "city": self.selectedCity, "prevState": self.prevSelectedState ?? self.selectedState, "prevCity": self.prevSelectedCity ?? self.selectedCity]
                            NotificationCenter.default.post(name: .newEventAdded, object: nil, userInfo: data)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }

            } catch {
                print("Failed to update event")
            }
        }
        else {
            
            // Add the event to Firestore under the "events" collection
            do {
                let docRef = db.collection("events").document()
                try docRef.setData(from: event) { error in
                     if error != nil {
                         print("Error adding event to Firestore")
                     } else {
                         print("Event successfully added to Firestore!")
                         // Navigate to the Show Post Page
                         let documentID = docRef.documentID
                    
                         self.showPost.eventId = documentID
                         self.showAlert(title: "Success", message: "Event created successfully") {
                             let data = ["state": self.selectedState, "city": self.selectedCity, "prevState": self.prevSelectedState ?? self.selectedState, "prevCity": self.prevSelectedCity ?? self.selectedCity]
                             NotificationCenter.default.post(name: .newEventAdded, object: nil, userInfo: data)
                             self.navigationController?.popViewController(animated: true)
                         }
                     }
                 }
            } catch {
                print("Error adding document!")
            }
        }
  
    }
    
    
    func removeEventFromUserLikes(eventId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No users found.")
                completion()
                return
            }
            
            let totalUsers = documents.count
            var processedUsers = 0
            
            for document in documents {
                let userId = document.documentID
                let likesRef = db.collection("users").document(userId).collection("likes").document(eventId)
                
                // Check if the eventId exists in the likes collection
                likesRef.getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error checking eventId for user \(userId): \(error.localizedDescription)")
                    } else if documentSnapshot?.exists == true {
                        // Proceed to delete the document if it exists
                        likesRef.delete { error in
                            if let error = error {
                                print("Error removing eventId from user \(userId): \(error.localizedDescription)")
                            } else {
                                print("Removed eventId from user \(userId)'s likes collection.")
                            }
                        }
                    }
                    
                    processedUsers += 1
                    
                    if processedUsers == totalUsers {
                        print("EventId removal from all likes collections complete.")
                        completion()
                    }
                }
            }
            
            if totalUsers == 0 {
                completion()
            }
        }
    }

    
    
     func getMenuImagePicker() -> UIMenu{
         let menuItems = [
             UIAction(title: "Camera",handler: {(_) in
                 self.pickUsingCamera()
             }),
             UIAction(title: "Gallery",handler: {(_) in
                 self.pickPhotoFromGallery()
             })
         ]
         
         return UIMenu(title: "Select source", children: menuItems)
     }
    
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }

    func pickPhotoFromGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1

        let photoPicker = PHPickerViewController(configuration: configuration)

        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }

    func hideKeyboardOnTapOutside() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func hideKeyboardOnTap() {
        view.endEditing(true)
    }

}

extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        dismiss(animated: true)

        print(results)

        let itemprovider = results.map(\.itemProvider)

        for item in itemprovider {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(
                    ofClass: UIImage.self,
                    completionHandler: { (image, error) in
                        DispatchQueue.main.async {
                            if let uwImage = image as? UIImage {
                                self.createPost.buttonTakePhoto.setImage(
                                    uwImage.withRenderingMode(.alwaysOriginal),
                                    for: .normal
                                )
                                self.pickedImage = uwImage
                            }
                        }
                    })
            }
        }
    }
}

extension CreatePostViewController: UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage {
            self.createPost.buttonTakePhoto.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        } else {
            // Do your thing for No image loaded...
        }
    }
}
