//
//  CreatePostViewController.swift
//  NeatMeet
//
//
//  Created by Gautam Raju on 10/28/24.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CreatePostViewController: UIViewController {

    var createPost = CreatePost()
    var pickedImage:UIImage?
    
    var currentUser:FirebaseAuth.User?
    let showPost = ShowPostViewController()
    let database = Firestore.firestore()

    var navController: UINavigationController?
    let locationAPI = LocationAPI()
    var citiesList: [City] = []
    var statesList: [State] = []
    var selectedState: State = State(name: "", isoCode: "")
    var selectedCity: City = City(name: "", stateCode: "")
    
    var eventId: String?
    var isEditingPost: Bool = false
    
    override func loadView() {
        view = createPost
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if isEditingPost, let eventId = eventId {
            createPost.headerLabel.text = "Update a Post"
            self.createPost.placeholderLabel.isHidden = true
            fetchEventDetails(for: eventId)
        }
        
        hideKeyboardOnTapOutside()
        addNotificationCenter()
        createPost.buttonTakePhoto.menu = getMenuImagePicker()
        addSaveButton()
        configureButtonActions()
        requestLocation()

        

    }
    
    private func fetchEventDetails(for eventId: String) {
        let db = Firestore.firestore()
        db.collection("events").document(eventId).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching event: \(error.localizedDescription)")
                return
            }

            guard let document = document, document.exists,
                  let event = try? document.data(as: Event.self) else {
                print("Failed to decode event data.")
                return
            }

            DispatchQueue.main.async {
                self?.populateFields(with: event)
            }
        }
    }

    private func populateFields(with event: Event) {
        createPost.eventNameTextField.text = event.name
        createPost.locationTextField.text = event.address
        createPost.descriptionTextField.text = event.eventDescription
        createPost.timePicker.date = event.eventDate

        selectedState = State(name: event.state, isoCode: "") // Adjust as needed
        selectedCity = City(name: event.city, stateCode: "")

        createPost.stateButton.setTitle(selectedState.name, for: .normal)
        createPost.cityButton.setTitle(selectedCity.name, for: .normal)
        print("This is String: \(event.imageUrl)")
        if !event.imageUrl.isEmpty {
            loadImage(from: event.imageUrl)
        }
    }

    private func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            image.withRenderingMode(.alwaysOriginal)
            DispatchQueue.main.async {
                self.createPost.buttonTakePhoto.setImage(image, for: .normal)
//                self.createPost.buttonTakePhoto.setBackgroundImage(image, for: .normal)
                self.pickedImage = image
            }
        }.resume()
    }

    
    
    
    private func requestLocation() {
        LocationManager.shared.getCurrentLocation { [weak self] result in
            guard let self = self else { return }
                
            Task {
                // Get all states first
                self.statesList = await self.locationAPI.getAllStates()
                    
                if let (detectedStateCode, detectedCity) = result {
                    // Find matching state in statesList using the ISO code
                    if let matchingState = self.statesList.first(where: { $0.isoCode == detectedStateCode }) {
                        self.selectedState = matchingState
                        // Get cities for the detected state
                        self.citiesList = await self.locationAPI.getAllCities(stateCode: matchingState.isoCode)
                            
                        // Find matching city
                        if let matchingCity = self.citiesList.first(where: { $0.name.lowercased() == detectedCity.lowercased() }) {
                            self.selectedCity = matchingCity
                        } else {
                            self.selectedCity = self.citiesList.first ?? City(name: "", stateCode: "")
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
                    self.createPost.stateButton.setTitle(self.selectedState.name, for: .normal)
                    self.createPost.cityButton.setTitle(self.selectedCity.name, for: .normal)
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
            customView: createPost.saveButton)
        createPost.saveButton.addTarget(
            self, action: #selector(onTapPost), for: .touchUpInside)
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func onTapPost() {
        // push to next screen.
        // set all the second screen variables
        guard let eName = createPost.eventNameTextField.text, !eName.isEmpty,
              let eLocation = createPost.locationTextField.text, !eLocation.isEmpty,
              let eDetails = createPost.descriptionTextField.text, !eDetails.isEmpty else {
            showAlert(title: "Missing Information", message: "Please fill all required fields.")
               return
        }
        let eDateTime = createPost.timePicker.date
        let ePhoto = createPost.buttonTakePhoto.imageView?.image
        
        // Need to upload the image to Firebase Storage and retrieve the URL for it to populate in the db
        var imageUrl: String? = nil
        if let image = ePhoto, let imageData = image.jpegData(compressionQuality: 0.8) {
            // Upload image to Firebase Storage
            let imageRef = Storage.storage().reference().child("eventImages/\(UUID().uuidString).jpg")
            
            imageRef.putData(imageData, completion: {(url, error) in
                if error == nil {
                    imageRef.downloadURL(completion: {(url, error) in
                        if error == nil {
                            imageUrl = url?.absoluteString
                            self.postEventToFirestore(eventName: eName, location: eLocation, description: eDetails, eventDate: eDateTime, imageUrl: imageUrl, eDetails: eDetails)
                        }
                    })
                }
            })
        }

    }
    
    func postEventToFirestore(eventName: String, location: String, description: String, eventDate: Date, imageUrl: String?, eDetails: String) {
        let db = Firestore.firestore()
    
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }
        
        // Create the event data
        let event = Event(name: eventName,
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
                   print("This an edit image: \(imageUrl!)")
                   try db.collection("events").document(eventId).setData(from: event) { error in
                       if error != nil {
                           print("Error updating event to Firestore")
                       } else {
                           print("Event successfully updated in Firestore!")
                           self.showPost.eventId = eventId
                           NotificationCenter.default.post(name: .contentEdited,object: nil)
                           self.navigationController?.popViewController(animated: true)
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
                         
                         self.navigationController?.pushViewController(self.showPost, animated: true)
                     }
                 }
            } catch {
                print("Error adding document!")
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

     func pickPhotoFromGallery(){
         var configuration = PHPickerConfiguration()
            configuration.filter = PHPickerFilter.any(of: [.images])
            configuration.selectionLimit = 1
            
            let photoPicker = PHPickerViewController(configuration: configuration)
            
            photoPicker.delegate = self
            present(photoPicker, animated: true, completion: nil)
     }
    
    func hideKeyboardOnTapOutside(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboardOnTap(){
        view.endEditing(true)
    }


}


extension CreatePostViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage{
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

extension CreatePostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.createPost.buttonTakePhoto.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.pickedImage = image
        }else{
            // Do your thing for No image loaded...
        }
    }
}

