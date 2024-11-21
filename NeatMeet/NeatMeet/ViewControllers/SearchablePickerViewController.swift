//
//  SearchablePickerViewController.swift
//  NeatMeet
//
//  Created by Damyant Jain on 11/21/24.
//


import UIKit

class SearchablePickerViewController<T: Searchable>: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private var allOptions: [T]
    private var filteredOptions: [T]
    private var selectedOption: T?
    private let notificationName: NSNotification.Name
    let searchablePickerView = SearchablePickerView()

    init(options: [T], selectedOption: T?, notificationName: NSNotification.Name) {
        self.allOptions = options
        self.filteredOptions = options
        self.selectedOption = selectedOption
        self.notificationName = notificationName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchablePickerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchablePickerView.tableView.delegate = self
        searchablePickerView.tableView.dataSource = self
        searchablePickerView.searchBar.delegate = self
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done", style: .done, target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel", style: .plain, target: self,
            action: #selector(cancelButtonTapped)
        )
    }

    @objc private func doneButtonTapped() {
        guard let selectedOption = selectedOption else { return }
        NotificationCenter.default.post(name: notificationName, object: selectedOption)
        dismiss(animated: true)
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = filteredOptions[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = filteredOptions[indexPath.row]
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredOptions = allOptions
        } else {
            filteredOptions = allOptions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        searchablePickerView.tableView.reloadData()
    }
}
