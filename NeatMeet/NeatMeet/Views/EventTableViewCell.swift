//
//  EventTableViewCell.swift
//  NeatMeet
//
//  Created by Damyant Jain on 10/30/24.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var eventNameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpWrapperCellView()
        setUpEventNameLabel()
        initConstraints()
    }

    func setUpWrapperCellView() {
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = UIColor(red: 248/255, green: 251/255, blue: 252/255, alpha: 1)
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }

    func setUpEventNameLabel() {
        eventNameLabel = UILabel()
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(eventNameLabel)
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
            
            //Event Name
            eventNameLabel.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            eventNameLabel.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 120),
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
