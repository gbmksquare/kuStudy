//
//  AppIconViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 01/01/2019.
//  Copyright © 2019 gbmKSquare. All rights reserved.
//

import UIKit

class AppIconViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private let icons: [(groupName: String, icons: [AppIcon])] = [
        ("Default", [
            AppIcon(imageName: "AppIcon", name: "Default", description: "Default App Icon"),
            AppIcon(imageName: "Alternative 1", name: "White Pencil", description: nil),
            AppIcon(imageName: "Black 1", name: "Black 1", description: nil),
            AppIcon(imageName: "Black 2", name: "Black 2", description: nil),
            AppIcon(imageName: "White 1", name: "White 1", description: nil),
            AppIcon(imageName: "White 2", name: "White 2", description: nil),
            AppIcon(imageName: "White 3", name: "White 3", description: nil),
            AppIcon(imageName: "White 4", name: "White 4", description: nil)
            ]),
        ("Korea University", [
            ]),
        ("April Fools", [
            AppIcon(imageName: "AprilFools1", name: "April Fool Icon", description: "Only available at April 1st!"),
            AppIcon(imageName: "AprilFools2", name: "April Fool Icon with White Pencil", description: "Only Available on April 1st!")
            ])
    ]
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Label.Settings.AppIcon
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        tableView.register(AppIconCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table
extension AppIconViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let icon = icons[indexPath.section].icons[indexPath.row]
        if icon.imageName == "AppIcon" {
            UIApplication.shared.setAlternateIconName(nil) { [weak self] _ in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            UIApplication.shared.setAlternateIconName(icon.imageName) { [weak self] _ in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return icons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return icons[section].groupName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons[section].icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppIconCell
        let icon = icons[indexPath.section].icons[indexPath.row]
        cell.iconImageView.image = icon.image
        cell.iconNameLabel.text = icon.name
        cell.iconDescriptionLabel.text = icon.description
        return cell
    }
}
