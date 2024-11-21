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

    private let tableView = UITableView()
    private let searchBar = UISearchBar()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupSearchBar()
        setupTableView()
        setupNavigationBar()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        tableView.reloadData()
    }
}
