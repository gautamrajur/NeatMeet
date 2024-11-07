//
//  CreatePostViewController.swift
//  NeatMeet
//
//
//  Created by Gautam Raju on 10/28/24.
//

import UIKit
import PhotosUI

class CreatePostViewController: UIViewController {

    var createPost = CreatePost()
    var pickedImage:UIImage?
    
    let showPost = ShowPostViewController()
    
    override func loadView() {
        view = createPost
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        hideKeyboardOnTapOutside()
        createPost.buttonTakePhoto.menu = getMenuImagePicker()
        
        addPostButton()

    }
 
    func addPostButton() {
        let profileButton = UIButton(type: .system)
        profileButton.setImage(
            UIImage(systemName: "plus.circle"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: profileButton)

        profileButton.addTarget(
            self, action: #selector(onTapPost), for: .touchUpInside)
    }
    
    @objc func onTapPost() {
        // push to next screen.
        // set all the second screen variables
        
        
        
        self.navigationController?.pushViewController(showPost, animated: true)
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

