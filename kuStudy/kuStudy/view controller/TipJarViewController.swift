//
//  TipJarViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import SnapKit
import StoreKit

class TipJarViewController: UIViewController {
    private lazy var table = UITableView(frame: .zero, style: .grouped)
    
    // Store
    private var products: [SKProduct]?
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizations.Settings.Table.Cell.Title.Tipjar
        setup()
        getProducts()
    }
}

// MARK: - Setup
extension TipJarViewController {
    private func setup() {
        func setupTableView() {
            table.delegate = self
            table.dataSource = self
            table.rowHeight = UITableViewAutomaticDimension
            table.estimatedRowHeight = UITableViewAutomaticDimension
            
            view.addSubview(table)
            table.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        func setupNavigation() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close(_:)))
        }
        
        setupTableView()
        setupNavigation()
    }
    
    func getProducts() {
        let identifiers: Set<String> = ["com.gbmksquare.kuapps.kuStudy.TipTier1",
                                        "com.gbmksquare.kuapps.kuStudy.TipTier2",
                                        "com.gbmksquare.kuapps.kuStudy.TipTier3"]
        
        let product = SKProductsRequest(productIdentifiers: identifiers)
        product.delegate = self
        product.start()
    }
}

// MARK: - Action
extension TipJarViewController {
    @objc func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Store
extension TipJarViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        self.products = products
        table.reloadData()
    }
}

// MARK: - Table
extension TipJarViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    // Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.numberOfLines = 0
        }
        if let product = products?[indexPath.row] {
            let formatter = NumberFormatter()
            formatter.formatterBehavior = .default
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            let priceString = formatter.string(from: product.price)!
            
            cell.textLabel?.text = product.localizedTitle + "\n\(priceString)"
            cell.detailTextLabel?.text = product.localizedDescription
        }
        return cell
    }
}
