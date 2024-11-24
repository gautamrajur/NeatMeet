//
//  Event.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/30/24.
import UIKit
import FirebaseFirestore

struct Event: Codable {
    @DocumentID var id: String?
    var name: String
    var likesCount: Int
    var datePublished: Date
    var publishedBy: String
    var address: String
    var city: String
    var state: String
    var imageUrl: String
    var eventDate: Date
    var eventDescription: String
    
    init(id: String? = nil,name: String, likesCount: Int, datePublished: Date, publishedBy: String, address: String, city: String, state: String, imageUrl: String, eventDate: Date, eventDescription: String) {
         self.id = id
         self.name = name
         self.likesCount = likesCount
         self.datePublished = datePublished
         self.publishedBy = publishedBy
         self.address = address
         self.city = city
         self.state = state
         self.imageUrl = imageUrl
         self.eventDate = eventDate
         self.eventDescription = eventDescription
     }
}

