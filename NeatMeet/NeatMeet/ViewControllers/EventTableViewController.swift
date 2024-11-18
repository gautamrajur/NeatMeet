//
//  EventTableViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/30/24.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return displayedEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "events", for: indexPath)
            as! EventTableViewCell
        let event = displayedEvents[indexPath.row]
        cell.selectionStyle = .none
        cell.eventNameLabel?.text = event.name
        cell.eventLocationLabel?.text = event.address
        cell.eventDateTimeLabel?.text = event.datePublished.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        cell.eventDateTimeLabel?.text = dateFormatter.string(from: event.datePublished)
        cell.eventImageView?.image = event.image
        cell.eventLikeLabel?.text = (String)(event.likesCount)
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
