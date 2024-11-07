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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setUpScrollView()
        setUpEventName()
        setUpLocation()
        setUpDateAndTime()
        setUpStateAndCity()
        setUpDescription()
        
        initConstraints()

    }
    
    func setUpScrollView() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setUpEventName() {
        labelEventName = UILabel()
        labelEventName.text = "Event Name"
        labelEventName.font = UIFont.boldSystemFont(ofSize: 24)
        labelEventName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEventName)
        
    }
    
    func setUpLocation() {
        labelLocation = UILabel()
        labelLocation.text = "Event Location"
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelLocation)
    }
    
    func setUpDateAndTime() {
        labelDateAndTime = UILabel()
        labelDateAndTime.text = "Event Time and Date"
        labelDateAndTime.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDateAndTime)
    }
    
    
    
    func setUpStateAndCity() {
        labelStateAndCity = UILabel()
        labelStateAndCity.text = "State and City"
        labelStateAndCity.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelStateAndCity)
    }
    
    func setUpDescription() {
        labelDescription = UILabel()
        labelDescription.text = "Description"
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDescription)
    }
    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            labelEventName.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            labelEventName.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            labelLocation.topAnchor.constraint(equalTo: labelEventName.bottomAnchor, constant: 32),
            labelLocation.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            labelDateAndTime.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 32),
            labelDateAndTime.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            labelStateAndCity.topAnchor.constraint(equalTo: labelDateAndTime.bottomAnchor, constant: 32),
            labelStateAndCity.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            labelDescription.topAnchor.constraint(equalTo: labelStateAndCity.bottomAnchor, constant: 32),
            labelDescription.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
