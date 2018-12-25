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
import CTFeedback
import SafariServices

class SettingsViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var footerView = AppVersionFooterView()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
    
    // MARK: - Action
    @objc private func handle(autoUpdate onOffSwitch: UISwitch) {
        let shouldAutoUpdate = onOffSwitch.isOn
        Preference.shared.shouldAutoUpdate = shouldAutoUpdate
        if shouldAutoUpdate == true {
            kuStudy.enableAutoUpdate()
        } else {
            kuStudy.disableAutoUpdate()
        }
    }
    
    private func presentUpdateInterval(cell: UITableViewCell, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: Localizations.Label.Settings.UpdateInterval, message: nil, preferredStyle: .actionSheet)
        var intervals: [Double] = [60, 180, 300, 600]
        #if DEBUG
        intervals.insert(1, at: 0)
        #endif
        intervals.forEach {
            let interval = $0
            let action = UIAlertAction(title: $0.readableTime, style: .default, handler: { [weak self] (_) in
                Preference.shared.updateInterval = interval
                kuStudy.update(updateInterval: interval)
                self?.tableView.reloadData()
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: Localizations.Alert.Action.Cancel, style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = tableView
        alert.popoverPresentationController?.sourceRect = cell.frame
        alert.popoverPresentationController?.permittedArrowDirections = .any
        present(alert, animated: true) {
            completion?()
        }
    }
    
    private func presentAppLibraryOrder() {
        let viewController = LibraryOrderViewController()
        let detailNavigation = UINavigationController(rootViewController: viewController)
        navigationController?.showDetailViewController(detailNavigation, sender: nil)
    }
    
    private func presentWidgetLibraryOrder() {
        let viewController = TodayExtensionOrderViewController()
        let detailNavigation = UINavigationController(rootViewController: viewController)
        navigationController?.showDetailViewController(detailNavigation, sender: nil)
    }
    
    private func presentAdvancedSettings(_ completion: (() -> Void)? = nil) {
        let viewController = AdvancedSettingsViewController()
        let detailNavigationController = UINavigationController(rootViewController: viewController)
        viewController.title = Localizations.Label.Settings.Advanced
        navigationController?.showDetailViewController(detailNavigationController, sender: true)
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
    
    // MARK: - Setup
    private func setup() {
        title = Localizations.Title.Settings
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = footerView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = SettingsMenu(rawValue: cell.tag) else { return true }
        switch menu {
        case .autoUpdate: return false
        default: return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
            let menu = SettingsMenu(rawValue: cell.tag) else { return }
        switch menu {
        case .autoUpdate: break
        case .autoUpdateInterval:
            presentUpdateInterval(cell: cell) { [weak self] in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
        case .appLibraryOrder:
            presentAppLibraryOrder()
        case .widgetLibraryOrder:
            presentWidgetLibraryOrder()
        case .advanced:
            presentAdvancedSettings()
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
        
        switch menuRow {
        case .autoUpdate:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "switchCell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "switchCell")
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            let onOffSwitch = UISwitch()
            onOffSwitch.isOn = Preference.shared.shouldAutoUpdate
            onOffSwitch.addTarget(self, action: #selector(handle(autoUpdate:)), for: .valueChanged)
            cell.accessoryView = onOffSwitch
            return cell
        case .autoUpdateInterval:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "value1Cell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            let interval = TimeInterval(Preference.shared.updateInterval)
            cell.detailTextLabel?.text = interval.readableTime
            return cell
        case .appLibraryOrder, .widgetLibraryOrder:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "disclosureCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "disclosureCell")
                cell.accessoryType = .disclosureIndicator
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            return cell
        case .advanced:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "normalCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "normalCell")
            }
            cell.tag = menuRow.tag
            cell.textLabel?.text = menuRow.title
            return cell
        }
    }
}
