//
//  SettingsTableViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2016. 1. 25..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit
import AcknowList
import Crashlytics
import CTFeedback

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizations.Main.Title.Preference
        appIconImageView.layer.cornerRadius = 8
        versionLabel.text = "kuStudy " + UIApplication.versionString
        clearsSelectionOnViewWillAppear = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // iOS Bug: http://stackoverflow.com/questions/19379510/uitableviewcell-doesnt-get-deselected-when-swiping-back-quickly
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        // Deselct cell if detail view does not match master view
        if UIDevice.current.userInterfaceIdiom == .pad {
            if (splitViewController?.childViewControllers.last?.childViewControllers.first is LibraryViewController) == true {
                if let indexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjust table footer view height to support dynamic type
        if let footer = tableView.tableFooterView {
            let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = footer.frame
            if frame.height != height {
                frame.size.height = height
                footer.frame = frame
                tableView.tableFooterView = footer
            }
        }
    }
}

extension SettingsTableViewController {
    @IBAction private func tapped(autoUpdate onOffSwitch: UISwitch) {
        let shouldAutoUpdate = onOffSwitch.isOn
        Preference.shared.shouldAutoUpdate = shouldAutoUpdate
        if shouldAutoUpdate == true {
            kuStudy.enableAutoUpdate()
        } else {
            kuStudy.disableAutoUpdate()
        }
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 4), (2, 3): return 0
        default: break
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return Localizations.Settings.Table.Section.Header.General
        case 1: return Localizations.Settings.Table.Section.Header.Share
        case 2: return Localizations.Settings.Table.Section.Header.Feedback
        case 3: return Localizations.Settings.Table.Section.Header.TipJar
        case 4: return Localizations.Settings.Table.Section.Header.About
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1: return Localizations.Settings.Table.Section.Footer.Review
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let title: String?
        switch cell.tag {
        case 100: title = Localizations.Settings.Table.Cell.Title.Order
        case 101: title = Localizations.Settings.Table.Cell.Title.TodayOrder
        case 102:
            title = Localizations.Settings.Table.Cell.Title.Maps
            cell.detailTextLabel?.text = Preference.shared.preferredMap == .apple
                ? Localizations.Settings.Table.Cell.Detail.AppleMap
                : Localizations.Settings.Table.Cell.Detail.GoogleMap
        case 103:
            let cell = cell as! SwitchCell
            cell.titleLabel.text = Localizations.Settings.Table.Cell.Title.AutoUpdate
            cell.onOffSwitch.isOn = Preference.shared.shouldAutoUpdate
            title = ""
        case 104:
            title = Localizations.Settings.Table.Cell.Title.UpdateInterval
            let interval = TimeInterval(Preference.shared.updateInterval)
            cell.detailTextLabel?.text = interval.readableTime
        case 800: title = Localizations.Settings.Table.Cell.Title.Feedback
        case 900: title = Localizations.Settings.Table.Cell.Title.OpenSource
        case 901: title = Localizations.Settings.Table.Cell.Title.ThanksTo
        case 998: title = Localizations.Settings.Table.Cell.Title.Recommend
        case 999: title = Localizations.Settings.Table.Cell.Title.Rate
        case 1004: title = Localizations.Settings.Table.Cell.Title.TipJar
        default: title = nil
        }
        cell.textLabel?.text = title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch  cell.tag {
        case 102: // Map
            if Preference.shared.preferredMap == .apple {
                Preference.shared.preferredMap = .google
                cell.detailTextLabel?.text = Localizations.Settings.Table.Cell.Detail.GoogleMap
            } else {
                Preference.shared.preferredMap = .apple
                cell.detailTextLabel?.text = Localizations.Settings.Table.Cell.Detail.AppleMap
            }
            tableView.deselectRow(at: indexPath, animated: true)
        case 104: // Update interval
            let alert = UIAlertController(title: Localizations.Settings.Table.Cell.Title.UpdateInterval, message: nil, preferredStyle: .actionSheet)
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
            present(alert, animated: true, completion: { [weak self] in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
        case 800: // Feedback
            let feedback = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(), localizedTopics: CTFeedbackViewController.defaultLocalizedTopics())
            feedback?.toRecipients = ["ksquareatm@gmail.com"]
            feedback?.useHTML = true
            let detailNavigationController = UINavigationController(rootViewController: feedback!)
            detailNavigationController.modalPresentationStyle = .formSheet
            present(detailNavigationController, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        case 1004: // Tip Jar
            let tipjar = TipJarViewController()
            let navigation = UINavigationController(rootViewController: tipjar)
            navigation.modalPresentationStyle = .formSheet
            present(navigation, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true )
        case 900: // Open source
            let path = Bundle.main.path(forResource: "Pods-kuStudy-acknowledgements", ofType: "plist")
            let acknowledgementViewController = AcknowListViewController(acknowledgementsPlistPath: path)
            let detailNavigationController = UINavigationController(rootViewController: acknowledgementViewController)
            acknowledgementViewController.title = Localizations.Settings.Table.Cell.Title.OpenSource
            navigationController?.showDetailViewController(detailNavigationController, sender: true)
        case 998: // Recommend to a friend
            tableView.deselectRow(at: indexPath, animated: true)
            let message = Localizations.Settings.Recommend.Message
            let url = URL(string: "https://geo.itunes.apple.com/kr/app/kustudy-golyeodaehaggyo-yeollamsil/id925255895?mt=8&ign-mpt=uo%3D4")! as Any
            let activityVC = UIActivityViewController(activityItems: [message, url], applicationActivities: nil)
            activityVC.popoverPresentationController?.permittedArrowDirections = .any
            activityVC.popoverPresentationController?.sourceView = cell
            activityVC.popoverPresentationController?.sourceRect = cell.bounds
            activityVC.completionWithItemsHandler = { (_, _, _, _) in
                
            }
            present(activityVC, animated: true, completion: { 
                Answers.logInvite(withMethod: "iOS", customAttributes: ["Device": UIDevice.current.model, "Version": UIDevice.current.systemVersion])
            })
        case 999: // App Store review
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
            tableView.deselectRow(at: indexPath, animated: true)
        default: break
        }
    }
}
