//
//  AdvancedSettingsViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 25/12/2018.
//  Copyright © 2018 gbmKSquare. All rights reserved.
//

import UIKit
import CTFeedback
import AcknowList
import SafariServices

class AdvancedSettingsViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private let menus = AdvancedSettingsMenu.self
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Label.Settings.Advanced
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Action
}

// MARK: - Table
extension AdvancedSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = AdvancedSettingsMenu(rawValue: cell.tag) else { return true }
        
        switch menu {
        case .version: return false
        default: return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = AdvancedSettingsMenu(rawValue: cell.tag) else { return }
        
        switch menu {
        case .appIcon:
            let viewController = AppIconViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .libraryCellType:
            let viewController = LibraryCellTypeViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .sectorCellType:
            let viewController = SectorCellTypeViewController()
            navigationController?.pushViewController(viewController, animated: true)
            
        case .openAppSettings:
            tableView.deselectRow(at: indexPath, animated: true)
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
            
        case .openLibrarySeatsLink:
            let address = Locale.current.languageCode == "ko" ? "https://librsv.korea.ac.kr/?lang=kr" : "https://librsv.korea.ac.kr/?lang=en"
            guard let url = URL(string: address) else { return }
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: false, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .openLibraryLink:
            let address = Locale.current.languageCode == "ko" ? "https://mlibrary.korea.ac.kr:444/ko" : "https://mlibrary.korea.ac.kr:444/en"
            guard let url = URL(string: address) else { return }
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: false, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .openAcademicCalendarLink:
            let address = Locale.current.languageCode == "ko" ? "http://registrar.korea.ac.kr/registrar/college/schedule_new.do?cYear=2019&hakGi=1&srCategoryId1=509" : "http://registrar.korea.ac.kr/registrar_en/college/schedule_new.do?cYear=2019&hakGi=1&srCategoryId1=398"
            guard let url = URL(string: address) else { return }
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
                let alert = UIAlertController(title: Localizations.Common.Error, message: Localizations.Alert.Message.AppStore.Failed, preferredStyle: .alert)
                let confirm = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true) {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
            
        case .bugReport:
            let feedback = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(),
                                                    localizedTopics: CTFeedbackViewController.defaultLocalizedTopics())
            feedback?.toRecipients = ["ksquareatm+kuapps@gmail.com"]
            feedback?.useHTML = true
            let detailNavigationController = UINavigationController(rootViewController: feedback!)
            detailNavigationController.modalPresentationStyle = .formSheet
            present(detailNavigationController, animated: true)
            
        case .tipJar:
            let tipjar = TipJarViewController()
            let navigation = UINavigationController(rootViewController: tipjar)
            navigation.modalPresentationStyle = .formSheet
            present(navigation, animated: true) { [weak self] in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            
        case .version: break
            
        case .thanksTo:
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThanksToViewController")
            navigationController?.pushViewController(viewController, animated: true)
            
        case .privacyPolicy:
            guard let url = URL(string: "https://gbmksquare.com/kuapps/kustudy/privacy_policy_v2.html") else { return }
            if let safari = kuAppsSafariViewController.open(url: url, entersReaderMode: true, alwaysInApp: false) {
                present(safari, animated: true, completion: nil)
            }
            
        case .openSource:
            let path = Bundle.main.path(forResource: "Pods-kuStudy-acknowledgements", ofType: "plist")
            let viewController = AcknowListViewController(acknowledgementsPlistPath: path)
            navigationController?.pushViewController(viewController, animated: true)
        }
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
        return menus.layout[section].menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuSection = AdvancedSettingsMenu.layout[indexPath.section].menus
        let menuRow = menuSection[indexPath.row]
        
        switch menuRow {
        // Disclosure
        case .appIcon, .libraryCellType, .sectorCellType, .bugReport, .tipJar, .thanksTo, .privacyPolicy, .openSource:
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
        case .openAppSettings, .openLibrarySeatsLink, .openLibraryLink, .openAcademicCalendarLink, .writeReview:
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
