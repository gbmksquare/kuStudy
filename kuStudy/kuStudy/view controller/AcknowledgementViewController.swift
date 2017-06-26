////
////  AcknowledgementViewController.swift
////  kuStudy
////
////  Created by BumMo Koo on 2016. 8. 14..
////  Copyright © 2016년 gbmKSquare. All rights reserved.
////
//
//import UIKit
//import kuStudyKit
//
//class AcknowledgementViewController: UIViewController {
//    @IBOutlet weak var tableView: UITableView!
//    
//    fileprivate var photographers: [Photographer] {
//        return PhotoProvider.sharedProvider.photographers
//    }
//    
//    // MARK: View
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
//    }
//}
//
//extension AcknowledgementViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return photographers.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let photographer = photographers[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "photographerCell", for: indexPath) as! PhotographerCell
//        cell.populate(photographer)
//        cell.presentingViewController = self
//        return cell
//    }
//}

