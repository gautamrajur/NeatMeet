//
//  ShowPostView.swift
//  NeetMeetPostPage
//
//  Created by Gautam Raju on 11/3/24.
//

import UIKit

class ShowPostView: UIView {
    
    var contentWrapper: UIScrollView!
    var labelEventName: UILabel!
    var labelLocation: UILabel!
    var labelDateAndTime: UILabel!
    var labelStateAndCity: UILabel!
    var labelDescription: UILabel!
    
    var eventImageView: UIImageView!
    var likeButton: UIButton!
    var labelLikeCount: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setUpScrollView()
        setUpEventName()
        setUpLocation()
        setUpDateAndTime()
        setUpStateAndCity()
        setUpDescription()
        setUpEventImage()
        setUpLikeButton()
        setUpLikeCountLabel()
        
        initConstraints()

    }
    
    func setUpLikeButton() {
          likeButton = UIButton(type: .system)
          likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
          likeButton.translatesAutoresizingMaskIntoConstraints = false
          contentWrapper.addSubview(likeButton)
      }
    
    func setUpLikeCountLabel() {
        labelLikeCount = UILabel()
        labelLikeCount.font = UIFont.systemFont(ofSize: 18)
        labelLikeCount.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelLikeCount)
    }
    
    func setUpEventImage() {
        eventImageView = UIImageView()
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(eventImageView)
    }
    
    
    func setUpScrollView() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setUpEventName() {
        labelEventName = UILabel()
        labelEventName.font = UIFont.boldSystemFont(ofSize: 24)
        labelEventName.numberOfLines = 1
        labelEventName.lineBreakMode = .byTruncatingTail
        labelEventName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEventName)
        
    }
    
    func setUpLocation() {
        labelLocation = UILabel()
        labelLocation.font = UIFont.systemFont(ofSize: 18)
        labelLocation.numberOfLines = 0
        labelLocation.lineBreakMode = .byWordWrapping
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelLocation)
    }
    
    func setUpDateAndTime() {
        labelDateAndTime = UILabel()
        labelDateAndTime.font = UIFont.systemFont(ofSize: 18)
        labelDateAndTime.lineBreakMode = .byWordWrapping
        labelDateAndTime.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDateAndTime)
    }
    
    
    
    func setUpStateAndCity() {
        labelStateAndCity = UILabel()
        labelStateAndCity.font = UIFont.systemFont(ofSize: 18)
        labelStateAndCity.lineBreakMode = .byWordWrapping
        labelStateAndCity.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelStateAndCity)
    }
    
    func setUpDescription() {
        labelDescription = UILabel()
        labelDescription.font = UIFont.systemFont(ofSize: 18)
        labelDescription.numberOfLines = 0
        labelDescription.lineBreakMode = .byWordWrapping
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDescription)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            eventImageView.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            eventImageView.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            eventImageView.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.8),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            
            labelEventName.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 32),
            labelEventName.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelEventName.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            labelEventName.bottomAnchor.constraint(lessThanOrEqualTo: labelLocation.topAnchor, constant: -16),
            
            labelLocation.topAnchor.constraint(equalTo: labelEventName.bottomAnchor, constant: 16),
            labelLocation.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelLocation.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            labelLocation.bottomAnchor.constraint(lessThanOrEqualTo: labelDateAndTime.topAnchor, constant: -16),
            
            labelDateAndTime.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 16),
            labelDateAndTime.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelDateAndTime.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            labelDateAndTime.bottomAnchor.constraint(lessThanOrEqualTo: labelStateAndCity.topAnchor, constant: -16),
            
            labelStateAndCity.topAnchor.constraint(equalTo: labelDateAndTime.bottomAnchor, constant: 16),
            labelStateAndCity.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelStateAndCity.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            labelStateAndCity.bottomAnchor.constraint(lessThanOrEqualTo: labelDescription.topAnchor, constant: -16),
            
            labelDescription.topAnchor.constraint(equalTo: labelStateAndCity.bottomAnchor, constant: 16),
            labelDescription.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            labelDescription.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),

            likeButton.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 20),
            likeButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 120),

            labelLikeCount.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            labelLikeCount.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8),
//            labelLikeCount.trailingAnchor.constraint(lessThanOrEqualTo: contentWrapper.trailingAnchor, constant: -20),
            labelLikeCount.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -32),


        ])
    }
    
    private func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.eventImageView.image = image
                }
            }
        }
    }
    
    func configureWithEvent(event: Event) {
        labelEventName.text = event.name
        labelLocation.text = "Location: \(event.address)"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        labelDateAndTime.text = "Date & Time: \(formatter.string(from: event.eventDate ))"
        labelStateAndCity.text = "State & City: \(event.state), \(event.city)"
        labelDescription.text = "Description: \(event.eventDescription)"
        loadImage(from: event.imageUrl)
    
    }
    
    func updateLikeCountLabel(count: Int) {
        labelLikeCount.text = "\(count)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
