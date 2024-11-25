//
//  NotificationName.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/29/24.
//

import Foundation

extension Notification.Name {
    static let selectState = Notification.Name("selectState")
    static let selectCity = Notification.Name("selectCity")
    static let loggedIn = Notification.Name("loggedIn")
    static let registered = Notification.Name("registered")
    static let selectStateCreatePost = Notification.Name("selectStateInCreatePost")
    static let selectCityCreatePost = Notification.Name("selectCityInCreatePost")
    static let contentEdited = Notification.Name("contentEdited")
}
