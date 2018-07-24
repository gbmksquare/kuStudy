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

enum SettingsMenu: Int {
    case autoUpdate = 103
    case autoUpdateInterval = 104
    case appLibraryOrder = 100
    case widgetLibraryOrder = 101
    case appStoreReview = 999
    case mediaProvider = 901
    case openSource = 900
    case donate = 1004
    
    var tag: Int { return rawValue }
    
    var title: String {
        switch self {
        case .autoUpdate: return Localizations.Label.Settings.AutoUpdate
        case .autoUpdateInterval: return Localizations.Label.Settings.UpdateInterval
        case .appLibraryOrder: return Localizations.Label.Settings.LibraryOrder
        case .widgetLibraryOrder: return Localizations.Label.Settings.TodayOrder
        case .appStoreReview: return Localizations.Label.Settings.AppStoreReview
        case .mediaProvider: return Localizations.Label.Settings.MediaProvider
        case .openSource: return Localizations.Label.Settings.OpenSource
        case .donate: return Localizations.Label.Settings.TipJar
        }
    }
    
    static let sectionTitles: [String?] = [Localizations.Label.Settings.GeneralHeader, Localizations.Label.Settings.FeedbackHeader, Localizations.Label.Settings.AboutHeader]
    static let sectionFooters: [String?] = [nil, Localizations.Label.Settings.ReviewFooter, nil]
    
    #if DEBUG
    static let layout: [[SettingsMenu]] = [
        [.autoUpdate, .autoUpdateInterval, .appLibraryOrder, .widgetLibraryOrder],
        [.appStoreReview],
        [.mediaProvider, .openSource, .donate]
    ]
    #else
    static let layout: [[SettingsMenu]] = [
        [.autoUpdate, .autoUpdateInterval, .appLibraryOrder, .widgetLibraryOrder],
        [.appStoreReview],
        [.mediaProvider, .openSource]]
    #endif
}

    class SettingsViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Action
    private func presentOpenSource() {
        let path = Bundle.main.path(forResource: "Pods-kuStudy-acknowledgements", ofType: "plist")
        let acknowledgementViewController = AcknowListViewController(acknowledgementsPlistPath: path)
        let detailNavigationController = UINavigationController(rootViewController: acknowledgementViewController)
        acknowledgementViewController.title = Localizations.Settings.Table.Cell.Title.OpenSource
        navigationController?.showDetailViewController(detailNavigationController, sender: true)
    }
    
    private func presentTipJar() {
        let tipjar = TipJarViewController()
        let navigation = UINavigationController(rootViewController: tipjar)
        navigation.modalPresentationStyle = .formSheet
        present(navigation, animated: true, completion: nil)
    }
    
    private func presentWriteReview() {
        let app = UIApplication.shared
        if let url = URL(string: "itms-apps://itunes.apple.com/us/app/kustudy/id925255895?mt=8&action=write-review"),
            app.canOpenURL(url) == true {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: Localizations.Common.Error, message: Localizations.Alert.Message.AppStore.Failed, preferredStyle: .alert)
            let confirm = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default, handler: nil)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Main.Title.Preference
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
        let menu = SettingsMenu(rawValue: cell.tag) else { return }
        switch menu {
        case .appStoreReview:
            presentWriteReview()
            tableView.deselectRow(at: indexPath, animated: true )
        case .openSource: presentOpenSource()
        case .donate:
            presentTipJar()
            tableView.deselectRow(at: indexPath, animated: true )
        default: break
        }
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsMenu.layout.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsMenu.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return SettingsMenu.sectionFooters[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsMenu.layout[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuSection = SettingsMenu.layout[indexPath.section]
        let menuRow = menuSection[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tag = menuRow.tag
        cell.textLabel?.text = menuRow.title
        return cell
    }
}
