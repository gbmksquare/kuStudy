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
import DZNEmptyDataSet

class TipJarViewController: UIViewController {
    private lazy var table = UITableView(frame: .zero, style: .grouped)
    
    // Store
    private var products: [SKProduct]?
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizations.Label.Settings.TipJar
        setup()
        getProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
}

// MARK: - Setup
extension TipJarViewController {
    private func setup() {
        func setupTableView() {
            table.delegate = self
            table.dataSource = self
            table.emptyDataSetSource = self
            table.rowHeight = UITableView.automaticDimension
            table.estimatedRowHeight = UITableView.automaticDimension
            
            view.addSubview(table)
            table.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        func setupNavigation() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close(_:)))
        }
        
        func setupPayment() {
            SKPaymentQueue.default().add(self)
        }
        
        setupTableView()
        setupNavigation()
        setupPayment()
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

// MARK: - Payment
extension TipJarViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                print("Deferred")
            case .purchasing:
                print("Purchasing")
            case .purchased:
                print("Purchased - \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Restored")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("Transaction removed")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restore finished")
    }
}

// MARK: - Table
extension TipJarViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = products?[indexPath.row], SKPaymentQueue.canMakePayments() == true {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            let alert = UIAlertController(title: Localizations.Common.Error, message: Localizations.Alert.Message.PaymentError, preferredStyle: .alert)
            let confirm = UIAlertAction(title: Localizations.Alert.Action.Confirm, style: .default, handler: nil)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        }
        
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
    
    // Empty
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .lightGray
        indicator.startAnimating()
        return indicator
    }
}
