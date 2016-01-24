//
//  LibraryViewController.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var libraryNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    // MARK: Model
    var libraryId: Int!
    var library: Library?
    var readingRooms = [ReadingRoom]()
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    private func setupView() {
        // Table view insets
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
        // Gradient
        // Graident
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = summaryView.bounds
        gradientLayer.colors = [UIColor(red: 48/255, green: 35/255, blue: 174/255, alpha: 1).CGColor,
            UIColor(red: 109/255, green: 170/255, blue: 215/255, alpha: 1).CGColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        summaryView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    private func updateView() {
        // Summary
        if let library = library {
            let libraryViewModel = LibraryViewModel(library: library)
            libraryNameLabel.text = libraryViewModel.name
            totalLabel.text = libraryViewModel.totalString
            availableLabel.text = libraryViewModel.availableString
        }
        
        // Table
        tableView.reloadData()
    }
    
    // MARK: Action
    private func refreshData() {
        kuStudy.requestLibrarySeatSummary(libraryId,
            success: { (library, readingRooms) -> Void in
                self.library = library
                self.readingRooms = readingRooms
                self.updateView()
            }) { (error) -> Void in
                
        }
    }

    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingRooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("readingRoomCell", forIndexPath: indexPath) as! ReadingRoomTableViewCell
        let readingRoom = readingRooms[indexPath.row]
        let readingRoomViewModel = ReadingRoomViewModel(library: readingRoom)
        
        cell.nameLabel.text = readingRoomViewModel.name
        cell.totalLabel.text = readingRoomViewModel.totalString
        cell.availableLabel.text = readingRoomViewModel.availableString
        cell.usedPercentage.progress = readingRoomViewModel.usedPercentage
        cell.usedPercentage.tintColor = readingRoomViewModel.usedPercentageColor
        
        return cell
    }
}
