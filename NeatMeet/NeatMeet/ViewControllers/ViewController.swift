//
//  ViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/21/24.
//

import UIKit

class ViewController: UIViewController {
    let firstScreen = LandingView()
    

    override func loadView() {
        view = firstScreen

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title="NeatMeet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .add, target: self,
                    action: #selector(onAddBarButtonTapped)
                )
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onAddBarButtonTapped(){
        let profileController = ProfileViewController()
        profileController.delegate = self
        navigationController?.pushViewController(profileController, animated: true)
            
        }


}

