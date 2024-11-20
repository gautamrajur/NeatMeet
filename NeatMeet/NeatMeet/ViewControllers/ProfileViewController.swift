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
    var delegate:ViewController!
    var pickedImage:UIImage?
    var events: [Event] = []
    var loggedInUser = User(email: "", name: "")
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
       
        
        profileScreen.eventTableView.delegate = self
        profileScreen.eventTableView.dataSource = self
        profileScreen.eventTableView.separatorStyle = .none
        
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
    
    
    
    func getAllEvents() async {
            do {
                events.removeAll()
                let snapshot = try await db.collection("events")
                    .whereField("publishedBy", isEqualTo: loggedInUser.email)
                    .getDocuments()
                for document in snapshot.documents {
                    let data = document.data()
                    if let name = data["name"] as? String,
                       let likesCount = ["likesCount"] as? Int,
                       let datePublished = ["datePublished"] as? Date,
                       let address = data["location"] as? String,
                       let city = data["city"] as? String,
                       let state = data["state"] as? String,
                       let imageUrl = data["imageUrls"] as? String,
                       let image = data["image"] as? UIImage,
                       let publishedBy = data["publishedBy"] as? String,
                       let eventDate = data["eventDate"] as? Date
                    {
                        let event = Event(
                            id: document.documentID,
                            name: name,
                            likesCount: likesCount,
                            datePublished: datePublished,
                            publishedBy: publishedBy,
                            address: address,
                            city: city,
                            state: state,
                            imageUrl: imageUrl,
                            eventDate: eventDate
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
//        profileScreen.textFieldName.text = "User 1"
//        profileScreen.textFieldEmail.text = "user1@gmail.com"
        do {
               if loggedInUser.email.isEmpty {
                   print("Logged-in user email is empty.")
                   return
               }

               let snapshot = try await db.collection("users")
                   .whereField("email", isEqualTo: loggedInUser.email)
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
        return cell
    }

}
