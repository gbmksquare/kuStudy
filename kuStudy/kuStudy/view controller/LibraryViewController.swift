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
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGradient()
    }
    
    // MARK: Setup
    private func setupView() {
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
    }
    
    private var gradient: CAGradientLayer?
    
    private func setupGradient() {
        self.gradient?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        self.gradient = gradient
        
        gradient.frame = summaryView.bounds
        gradient.colors = kuStudyGradientColor
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        summaryView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    // MARK: Action
    private func fetchData() {
        kuStudy.requestLibrarySeatSummary(libraryId,
            success: { [unowned self] (library, readingRooms) -> Void in
                self.library = library
                self.readingRooms = readingRooms
                self.updateDataInView()
            }) { (error) -> Void in
                
        }
    }
    
    private func updateDataInView() {
        if let library = library {
            let libraryViewModel = LibraryViewModel(library: library)
            libraryNameLabel.text = libraryViewModel.name
            totalLabel.text = libraryViewModel.totalString
            availableLabel.text = libraryViewModel.availableString
        }
        tableView.reloadData()
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
        cell.populate(readingRoomViewModel)
        return cell
    }
}
