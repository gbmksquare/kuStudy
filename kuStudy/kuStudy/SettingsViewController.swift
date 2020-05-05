//
//  SettingsViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 24/07/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit
import StoreKit
import AcknowList
import kuStudyKit
import SafariServices

class SettingsViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var footerView = AppVersionFooterView()
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .close,
                               target: self,
                               action: #selector(tap(close:)))
    }()
    
    // MARK: - Data
    private let menus = SettingsOption.self
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        title = "settings".localized()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [closeButton]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footerView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if !DEBUG
        SKStoreReviewController.requestReview()
        #endif
        
        // iOS Bug: http://stackoverflow.com/questions/19379510/uitableviewcell-doesnt-get-deselected-when-swiping-back-quickly
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // Deselct cell if detail view does not match master view
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (splitViewController?.children.last?.children.first is LibraryViewController) == true {
                if let indexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeTableFooterView()
    }
    
    // MARK: - User Interaction
    @objc
    private func tap(close sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // MARK: - Action
    private func presentAppLibraryOrder() {
        let viewController = LibraryOrderViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func resizeTableFooterView() {
        if let footer = tableView.tableFooterView {
            let height = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = footer.frame
            if frame.height != height {
                frame.size.height = height
                footer.frame = frame
                tableView.tableFooterView = footer
            }
        }
    }
}

// MARK: - Table
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = SettingsOption(rawValue: cell.tag) else { return true }
        switch menu {
        case .version:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = SettingsOption(rawValue: cell.tag) else { return }
        switch menu {
        case .appIcon:
            let viewController = AppIconViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .appLibraryOrder:
            presentAppLibraryOrder()
            
        case .appSettings:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
            
        case .linkStudyArea:
            let url = Locale.current.languageCode == "ko" ? URL.studyAreaURL : URL.studyAreaURLInternational
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: false, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .linkLibrary:
            let url = Locale.current.languageCode == "ko" ? URL.libraryURL : URL.libraryURLInternational
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: false, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .linkCalendar:
            let url = Locale.current.languageCode == "ko" ? URL.academicCalendarURL : URL.academicCalendarURLInternational
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: false, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .writeReview:
            let app = UIApplication.shared
            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/kustudy/id925255895?mt=8&action=write-review"),
                app.canOpenURL(url) == true {
                app.open(url, options: [:]) { [weak self] (_) in
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "error".localized(),
                                              message: "openAppStoreFailure".localized(),
                                              preferredStyle: .alert)
                let confirm = UIAlertAction(title: "confirm".localized(),
                                            style: .default,
                                            handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true) {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
            
        case .tipJar:
            let tipjar = TipJarViewController()
            let navigation = UINavigationController(rootViewController: tipjar)
            present(navigation, animated: true) { [weak self] in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            
        case .version: break
            
        case .terms:
            presentWebpage(url: URL.termsURL)
            
        case .privacyPolicy:
            presentWebpage(url: URL.privacyPolicyURL)
            
        case .openSource:
            let path = Bundle.main.path(forResource: "Pods-kuStudy-acknowledgements", ofType: "plist")
            let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
            navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return menus.layout.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menus.layout[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return menus.layout[section].footer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.layout[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuSection = menus.layout[indexPath.section]
        let menuRow = menuSection.rows[indexPath.row]
        
        switch menuRow {
        case .appIcon, .appLibraryOrder, .tipJar, .terms, .privacyPolicy, .openSource:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "disclosureCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "disclosureCell")
                cell.accessoryType = .disclosureIndicator
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            return cell
        // Detail
        case .version:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "value1Cell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            cell.detailTextLabel?.text = UIApplication.shared.versionString
            return cell
        // Plain style
        case .appSettings, .linkStudyArea, .linkLibrary, .linkCalendar, .writeReview:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "plainCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "plainCell")
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            return cell
        }
    }
}
