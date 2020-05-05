//
//  TipJarViewController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 8. 25..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import StoreKit
import os.log

class TipJarViewController: UIViewController {
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .close,
                               target: self,
                               action: #selector(tap(close:)))
    }()
    
    private lazy var restoreButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "restore".localized(),
                               style: .plain,
                               target: self,
                               action: #selector(tap(restore:)))
    }()
    
    // MARK: - Data
    private var products: [SKProduct]?
    private var productRequest: SKProductsRequest?
    
    private let identifiers: Set<String> = [
        "com.gbmksquare.kuapps.kuStudy.TipTier2",
        "com.gbmksquare.kuapps.kuStudy.TipTier3",
        "com.gbmksquare.kuapps.kuStudy.TipTier5",
        "com.gbmksquare.kuapps.kuStudy.TipTier9"
    ]
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        func setupPayment() {
            SKPaymentQueue.default().add(self)
        }
        setupPayment()
        
        title = "tipJar".localized()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.leftBarButtonItems = [restoreButton]
        navigationItem.rightBarButtonItems = [closeButton]
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - User interaction
    @objc
    private func tap(close sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc
    private func tap(restore sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Action
    private func updateView() {
        tableView.reloadData()
    }
    
    private func getProducts() {
        let request = SKProductsRequest(productIdentifiers: identifiers)
        productRequest = request
        request.delegate = self
        request.start()
    }
}

// MARK: - Store
extension TipJarViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    func requestDidFinish(_ request: SKRequest) {
        os_log(.info, log: .store, "Store request finished")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        os_log(.error, log: .store, "Store request failed - %{PUBLIC}", error.localizedDescription)
    }
}

// MARK: - Payment
extension TipJarViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred:
                os_log(.debug, log: .store, "Deferred - %{PRIVATE}@", transaction.payment.productIdentifier)
            case .purchasing:
                os_log(.debug, log: .store, "Purchasing - %{PRIVATE}@", transaction.payment.productIdentifier)
            case .purchased:
                os_log(.debug, log: .store, "Purchased - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                os_log(.error, log: .store, "Failed - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                os_log(.debug, log: .store, "Restored - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            @unknown default:
                fatalError()
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        os_log(.debug, log: .store, "Restore finished")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        os_log(.debug, log: .store, "Transaction removed")
    }
}

// MARK: - Table
extension TipJarViewController: UITableViewDelegate, UITableViewDataSource {
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = products?[indexPath.row], SKPaymentQueue.canMakePayments() == true {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            let alert = UIAlertController(title: "error".localized(),
                                          message: "paymentFailure".localized(),
                                          preferredStyle: .alert)
            let confirm = UIAlertAction(title: "confirm".localized(),
                                        style: .default,
                                        handler: nil)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
