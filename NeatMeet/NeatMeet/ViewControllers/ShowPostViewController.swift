//
//  ShowPostViewController.swift
//  NeetMeetPostPage
//
//  Created by Gautam Raju on 11/3/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

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
        setUpEditButton()
        addEditNotificationObserver()
    }
   
    
    func addEditNotificationObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(fetchUpdatedDeta(notification:)),
            name: .newEventAdded, object: nil)
    }
    
    @objc func fetchUpdatedDeta(notification: Notification) {
            Task {
                fetchEventAndDisplay(eventId: eventId)
            }
        
    }

    func setUpEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(onEditBarButtonTapped)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false

    }

    @objc func onEditBarButtonTapped() {
        let createPostVC = CreatePostViewController()
        createPostVC.isEditingPost = true
        createPostVC.eventId = eventId
        navigationController?.pushViewController(createPostVC, animated: true)
    }


    @objc func didTapLikeButton() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in") // Or take him to logiin page
            return
        }
        
        checkIfUserLikedEvent(userId: userId, eventId: eventId) { [weak self] alreadyLiked in
            if alreadyLiked {
                print("User has already liked this event.")
                self?.showAlert(title: "Hey !", message: "User has already liked this event.")
            } else {
                self?.incrementLikeCount(eventId: self?.eventId ?? "") {
                    self?.recordUserLike(userId: userId, eventId: self?.eventId ?? "")
                    self?.fetchLatestLikeCount(eventId: self?.eventId ?? "")
                }
            }
        }
    }

    func checkIfUserLikedEvent(userId: String, eventId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userLikesRef = db.collection("users").document(userId).collection("likes")

        userLikesRef.document(eventId).getDocument { document, error in
            if let error = error {
                print("Error checking user liked the event")
                completion(false)
                return
            }
            completion(document?.exists == true)
        }
    }

    func recordUserLike(userId: String, eventId: String) {
        let db = Firestore.firestore()
        let userLikesRef = db.collection("users").document(userId).collection("likes")

        userLikesRef.document(eventId).setData([:]) { error in
            if let error = error {
                print("Error recording user like")
            }
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
                NotificationCenter.default.post(name: .likeUpdated, object: nil)
                completion()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func fetchLatestLikeCount(eventId: String) {
        let db = Firestore.firestore()

        db.collection("events").document(eventId).getDocument { [weak self] (document, error) in
            if let error = error {
                print("Error fetching latest like count")
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
                print("Error fetching event: \(error.localizedDescription)")
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
                    
                    if let currentUserId = Auth.auth().currentUser?.uid,
                      currentUserId == event.publishedBy {
                       self?.navigationItem.rightBarButtonItem?.isEnabled = true
                   } else {
                       self?.navigationItem.rightBarButtonItem?.isEnabled = false
                   }
                }
            } catch {
                print("Error decoding event data: \(error.localizedDescription)")
            }
        }
    }
}
