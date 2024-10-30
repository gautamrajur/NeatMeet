//
//  EventTableViewCell.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/30/24.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var eventImageView: UIImageView!
    var eventNameLabel: UILabel!
    var eventLocationLabel: UILabel!
    var eventDateTimeLabel: UILabel!
    var eventLikeLabel: UILabel!
    var eventLikeImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpWrapperCellView()
        setUpEventImageView()
        setUpEventNameLabel()
        setUpEventLocationLabel()
        setUpEventDateTimeLabel()
        initConstraints()
    }

    func setUpWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = UIColor(
            red: 248 / 255, green: 251 / 255, blue: 252 / 255, alpha: 1)
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }

    func setUpEventImageView() {
        eventImageView = UIImageView()
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(eventImageView)
    }

    func setUpEventNameLabel() {
        eventNameLabel = UILabel()
        eventNameLabel.font = UIFont(name: "Arial-BoldMT", size: 16)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventNameLabel.numberOfLines = 1
        eventNameLabel.lineBreakMode = .byTruncatingTail
        wrapperCellView.addSubview(eventNameLabel)

    }

    func setUpEventLocationLabel() {
        eventLocationLabel = UILabel()
        eventLocationLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)
        eventLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(eventLocationLabel)
    }
    func setUpEventDateTimeLabel() {
        eventDateTimeLabel = UILabel()
        eventDateTimeLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        eventDateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(eventDateTimeLabel)
    }

    func initConstraints() {

        NSLayoutConstraint.activate([

            //Wrapper Cell View
            wrapperCellView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            wrapperCellView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            //Event Image
            eventImageView.topAnchor.constraint(
                equalTo: wrapperCellView.topAnchor, constant: 5),
            eventImageView.leadingAnchor.constraint(
                equalTo: wrapperCellView.leadingAnchor, constant: 5),
            eventImageView.bottomAnchor.constraint(
                equalTo: wrapperCellView.bottomAnchor, constant: -5),
            eventImageView.widthAnchor.constraint(equalToConstant: 120),

            //Event Name
            eventNameLabel.leadingAnchor.constraint(
                equalTo: eventImageView.trailingAnchor, constant: 6),
            eventNameLabel.topAnchor.constraint(
                equalTo: wrapperCellView.topAnchor, constant: 20),
            eventNameLabel.trailingAnchor.constraint(
                equalTo: wrapperCellView.trailingAnchor, constant: -5),

            //Event Location
            eventLocationLabel.leadingAnchor.constraint(
                equalTo: eventImageView.trailingAnchor, constant: 6),
            eventLocationLabel.topAnchor.constraint(
                equalTo: eventNameLabel.bottomAnchor, constant: 6),

            //Event Date Time
            eventDateTimeLabel.leadingAnchor.constraint(
                equalTo: eventImageView.trailingAnchor, constant: 6),
            eventDateTimeLabel.topAnchor.constraint(
                equalTo: eventLocationLabel.bottomAnchor, constant: 6),

            wrapperCellView.heightAnchor.constraint(equalToConstant: 120),
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
