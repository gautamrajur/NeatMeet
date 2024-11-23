//
//  ShowPostViewController.swift
//  NeetMeetPostPage
//
//  Created by Gautam Raju on 11/3/24.
//

import UIKit
import FirebaseFirestore

class ShowPostViewController: UIViewController {

    var showPost = ShowPostView()
    var eventId: String = ""

    override func loadView() {
        view = showPost
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEventAndDisplay(eventId: eventId)
        showPost.likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    @objc func didTapLikeButton() {
        incrementLikeCount(eventId: eventId) { [weak self] in
            self?.fetchLatestLikeCount(eventId: self?.eventId ?? "")
        }
    }

    func incrementLikeCount(eventId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventId)

        eventRef.updateData([
            "likesCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("Error incrementing like count: \(error.localizedDescription)")
            } else {
                print("Like count incremented successfully!")
                completion() 
            }
        }
    }

    func fetchLatestLikeCount(eventId: String) {
        let db = Firestore.firestore()

        db.collection("events").document(eventId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching latest like count: \(error.localizedDescription)")
                return
            }

            guard let document = document else {
                print("Event document does not exist")
                return
            }

            if let likesCount = document.data()?["likesCount"] as? Int {
                DispatchQueue.main.async {
                    self?.showPost.updateLikeCountLabel(count: likesCount)
                }
            }
        }
    }

    func fetchEventAndDisplay(eventId: String) {
        let db = Firestore.firestore()

        db.collection("events").document(eventId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching event")
                return
            }

            guard let document = document else {
                print("Event document does not exist")
                return
            }

            do {
                let event = try document.data(as: Event.self)
                DispatchQueue.main.async {
                    self?.showPost.configureWithEvent(event: event)
                    self?.showPost.updateLikeCountLabel(count: event.likesCount)
                }
            } catch {
                print("Error decoding event data")
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Only pop if this is the back button being pressed
//        if isMovingFromParent {
//            navigationController?.setViewControllers([LandingViewController()], animated: true)
//         }
//    }

}

