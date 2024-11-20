//
//  EventTableViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/30/24.
//

import UIKit
import SDWebImage

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return displayedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "events", for: indexPath)
            as! EventTableViewCell
        let event = displayedEvents[indexPath.row]
        
        cell.selectionStyle = .none
        cell.eventNameLabel?.text = event.name
        cell.eventLocationLabel?.text = event.address

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        cell.eventDateTimeLabel?.text = dateFormatter.string(from: event.eventDate)
        cell.eventLikeLabel?.text = "\(event.likesCount)"
        if let imageUrl = URL(string: event.imageUrl) {
            cell.eventImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "event_placeholder"))
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let event = displayedEvents[indexPath.row]
        let showPostViewController = ShowPostViewController()
        navigationController?.pushViewController(
            showPostViewController, animated: true)
    }

}
