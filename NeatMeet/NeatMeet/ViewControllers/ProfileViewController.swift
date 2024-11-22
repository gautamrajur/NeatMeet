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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    let profileScreen = ProfileView()
    var delegate:LandingViewController!
    var pickedImage:UIImage?
    var events: [Event] = []
    var loggedInUser = User(email: "", name: "", id: UUID(uuidString: "E13F8CDD-44C1-49CC-864B-F11C283ACD91") ?? UUID())
    let db = Firestore.firestore()
    
    override func loadView() {
        view=profileScreen
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        profileScreen.editButton.menu = getMenuImagePicker()
        displayAllEvents()
        displayUserDetails()
        profileScreen.buttonSave.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
       
        
        profileScreen.eventTableView.delegate = self
        profileScreen.eventTableView.dataSource = self
        profileScreen.eventTableView.separatorStyle = .none
        
    }
    
    @objc func onSaveButtonTapped(){
        let oldUserId = loggedInUser.id
        if let textFieldEmail = profileScreen.textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let textFieldName = profileScreen.textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            if textFieldEmail.isEmpty {
                showAlert(title: "Email cannot be empty!", message: "Please enter an email.")
                return        }
            if textFieldName.isEmpty {
                showAlert(title: "Name cannot be empty!", message: "Please enter a name.")
                return
            }
            
            db.collection("users").document(oldUserId.uuidString).updateData([
                "email": textFieldEmail,
                "name": textFieldName
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to update profile in Firestore: \(error.localizedDescription)")
                    return
                }
               
//                if let currentUser = Auth.auth().currentUser {
//                    currentUser.updateEmail(to: textFieldEmail) { error in
//                        if let error = error {
//                            self.showAlert(title: "Error", message: "Failed to update email in Authentication: \(error.localizedDescription)")
//                        } else {
//                            self.showAlert(title: "Success", message: "Profile updated successfully.")
//                            self.loggedInUser.email = textFieldEmail
//                        }
//                    }
//                } else {
//                    self.showAlert(title: "Error", message: "No authenticated user found.")
//                }
            }
        }
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
                let userIdString = loggedInUser.id.uuidString
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
                       let publishedByString = data["publishedBy"] as? String,
                       let publishedBy = UUID(uuidString: publishedByString),
                       let eventDate = data["eventDate"] as? Timestamp
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
                            eventDate: eventDate.dateValue()
                        )
                        events.append(event)
                        events.sort { $0.eventDate > $1.eventDate }
                        self.profileScreen.eventTableView.reloadData()
                    }
                }

            } catch {
                print("Error getting documents: \(error)")
            }
        }
    
    

    
    func setUpProfileData() async{
        do {
               
               if loggedInUser.email.isEmpty, let currentUser = Auth.auth().currentUser {
                    loggedInUser.email = currentUser.email ?? ""
                }
            
               let userIdString = loggedInUser.id.uuidString
               let snapshot = try await db.collection("users")
                       .whereField("id", isEqualTo: userIdString)
                       .getDocuments()

               if snapshot.documents.isEmpty {
                   print("No user found with the given email.")
                   return
               }

               if let document = snapshot.documents.first {
                   let data = document.data()
                   if let name = data["name"] as? String,
                      let email = data["email"] as? String {
                       profileScreen.textFieldName.text = name
                       profileScreen.textFieldEmail.text = email
                   } else {
                       print("Invalid data format.")
                   }
               }
           } catch {
               print("Error fetching user data: \(error)")
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

}
