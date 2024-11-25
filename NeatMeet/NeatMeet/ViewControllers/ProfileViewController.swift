//
//  ProfileViewController.swift
//  NeatMeet
//
//  Created by Saniya Anklesaria on 10/22/24.
//
import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    let profileScreen = ProfileView()
    var delegate:LandingViewController!
    var pickedImage:UIImage?
    var events: [Event] = []
    let db = Firestore.firestore()
    let storage = Storage.storage()

    
    override func loadView() {
        view=profileScreen
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addEditNotiifcationObservor()
        profileScreen.editButton.menu = getMenuImagePicker()
        displayAllEvents()
        displayUserDetails()
        profileScreen.buttonSave.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        profileScreen.eventTableView.delegate = self
        profileScreen.eventTableView.dataSource = self
        profileScreen.eventTableView.separatorStyle = .none
        
    }
    
    @objc func onSaveButtonTapped() {
        guard let textFieldEmail = profileScreen.textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let textFieldName = profileScreen.textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            showAlert(title: "Error", message: "Please fill out all fields.")
            return
        }

        if textFieldEmail.isEmpty || textFieldName.isEmpty {
            showAlert(title: "Error", message: "Name and email cannot be empty!")
            return
        }
        
        if !isValidEmail(textFieldEmail) {
                showAlert(title: "Invalid Email!", message: "Please enter a valid email address.")
                return
            }

        Task {
            do {
                var updatedImageUrl = UserManager.shared.loggedInUser?.imageUrl ?? ""
                if let userIdString = UserManager.shared.loggedInUser?.id {
                    try await db.collection("users").document(userIdString).updateData([
                        "email": textFieldEmail,
                        "name": textFieldName,
                        "imageUrl": updatedImageUrl
                    ])
                    
                    UserManager.shared.loggedInUser?.email = textFieldEmail
                    UserManager.shared.loggedInUser?.name = textFieldName
                    UserManager.shared.loggedInUser?.imageUrl = updatedImageUrl

                    showAlert(title: "Success", message: "Profile updated successfully.")
                } else {
                    showAlert(title: "Error", message: "No logged-in user ID found.")
                }
            } catch {
                showAlert(title: "Error", message: "Failed to update profile in Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func displayAllEvents() {
           Task {
               await getAllEvents()
           }
       }
    
    @objc func displayUserDetails() {
           Task {
               await setUpProfileData()
           }
       }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
    func getAllEvents() async {
            do {
                
                events.removeAll()
                if let userIdString = UserManager.shared.loggedInUser?.id{
                    let snapshot = try await db.collection("events")
                        .whereField("publishedBy", isEqualTo: userIdString)
                        .getDocuments()
                    for document in snapshot.documents {
                        let data = document.data()
                        if let name = data["name"] as? String,
                           let likesCount = data["likesCount"] as? Int,
                           let datePublished = data["datePublished"] as? Timestamp,
                           let address = data["address"] as? String,
                           let city = data["city"] as? String,
                           let state = data["state"] as? String,
                           let imageUrl = data["imageUrl"] as? String,
                           let publishedBy = data["publishedBy"] as? String,
                           let eventDate = data["eventDate"] as? Timestamp,
                           let eDetails = data["eventDescription"] as? String
                        {
                            let event = Event(
                                id: document.documentID,
                                name: name,
                                likesCount: likesCount,
                                datePublished: datePublished.dateValue(),
                                publishedBy: publishedBy,
                                address: address,
                                city: city,
                                state: state,
                                imageUrl: imageUrl,
                                eventDate: eventDate.dateValue(),
                                eventDescription: eDetails
                            )
                            events.append(event)
                            events.sort { $0.eventDate > $1.eventDate }
                            self.profileScreen.eventTableView.reloadData()
                        }
                    }
                }

            } catch {
                print("Error getting documents: \(error)")
            }
        }
    
    

    
    func setUpProfileData() async {	
        do {
            guard let userIdString = UserManager.shared.loggedInUser?.id else {
                print("No logged-in user ID found.")
                return
            }
            let snapshot = try await db.collection("users").document(userIdString).getDocument()
            
            guard let data = snapshot.data() else {
                print("No user found with the given ID.")
                return
            }
            
            if let name = data["name"] as? String,
               let email = data["email"] as? String,
               let imageUrl = data["imageUrl"] as? String {
                
                profileScreen.textFieldName.text = name
                profileScreen.textFieldEmail.text = email
                
                if let imageUrlURL = URL(string: imageUrl) {
                    profileScreen.imageContacts.sd_setImage(
                        with: imageUrlURL,
                        placeholderImage: UIImage(systemName: "person.fill")
                    )
                }
                
                UserManager.shared.loggedInUser?.name = name
                UserManager.shared.loggedInUser?.email = email
                UserManager.shared.loggedInUser?.imageUrl = imageUrl
                
            } else {
                print("Invalid user data format.")
            }
        } catch {
            print("Error fetching user data from Firestore: \(error.localizedDescription)")
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
    
    
       
    
    
       
       //MARK: pick Photo using Gallery...
       func pickPhotoFromGallery(){
           var configuration = PHPickerConfiguration()
           configuration.filter = PHPickerFilter.any(of: [.images])
           configuration.selectionLimit = 1
           
           let photoPicker = PHPickerViewController(configuration: configuration)
           
           photoPicker.delegate = self
           present(photoPicker, animated: true, completion: nil)
           
       }
    
        func pickUsingCamera(){
                let cameraController = UIImagePickerController()
                cameraController.sourceType = .camera
                cameraController.allowsEditing = true
                cameraController.delegate = self
                present(cameraController, animated: true)
            }


}
extension ProfileViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: { (image, error) in
                    DispatchQueue.main.async{
                        if let uwImage = image as? UIImage {
                                                   self.profileScreen.imageContacts.image = uwImage
                                                   self.pickedImage = uwImage
                                               }
                    }
                })
            }
        }
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "events", for: indexPath)
            as! EventTableViewCell
        let event = events[indexPath.row]
        cell.selectionStyle = .none
        cell.eventNameLabel?.text = event.name
        cell.eventLocationLabel?.text = event.address
        cell.eventDateTimeLabel?.text = event.eventDate.description
        cell.eventLikeLabel?.text = (String)(event.likesCount)
        if let imageUrl = URL(string: event.imageUrl) {
            cell.eventImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "event_placeholder"))
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let event = events[indexPath.row]
        let showPostViewController = ShowPostViewController()
        showPostViewController.eventId = event.id!
        navigationController?.pushViewController(
            showPostViewController, animated: true)
    }
    
    func addEditNotiifcationObservor() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(displayAllEvents),
            name: .contentEdited, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(displayAllEvents),
            name: .likeUpdated, object: nil)
    }
    

}
