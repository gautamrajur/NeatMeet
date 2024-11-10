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
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "events", for: indexPath)
            as! EventTableViewCell
        let event = events[indexPath.row]
        cell.selectionStyle = .none
        cell.eventNameLabel?.text = event.name
        cell.eventLocationLabel?.text = event.location
        cell.eventDateTimeLabel?.text = event.dateTime
        cell.eventImageView?.image = event.image
        cell.eventLikeLabel?.text = (String)(event.likeCount!)
        return cell
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let event = events[indexPath.row]
        let showPostViewController = ShowPostViewController()
        navigationController?.pushViewController(
            showPostViewController, animated: true)
    }

}
