//
//  SearchEventViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 11/9/24.
//

import UIKit

extension LandingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            displayedEvents = events
        } else {
            self.displayedEvents.removeAll()

            displayedEvents = events.filter { event in
                event.name.lowercased().contains(searchText.lowercased())
            }
        }
        self.landingView.eventTableView.reloadData()
    }
}
