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
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TipItemCell.self,
                                forCellWithReuseIdentifier: TipItemCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var chromView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        return view
    }()
    
    private lazy var activitiyIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .white
        indicator.startAnimating()
        return indicator
    }()
    
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
        dismissProcesing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - Setup
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
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(chromView)
        chromView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        chromView.addSubview(activitiyIndicatorView)
        activitiyIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(80)
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
        collectionView.reloadData()
    }
    
    private func getProducts() {
        let request = SKProductsRequest(productIdentifiers: identifiers)
        productRequest = request
        request.delegate = self
        request.start()
    }
    
    private func presentPurchaseSuccess() {
        let alert = UIAlertController(title: "success".localized(),
                                      message: "paymentSuccess".localized(),
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "confirm".localized(),
                                    style: .default,
                                    handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
        
        let confettiView = ConfettiView(frame: view.bounds)
        view.addSubview(confettiView)
        confettiView.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            confettiView.stopAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                confettiView.removeFromSuperview()
            }
        }
    }
    
    private func presentPurchaseFailure() {
        let alert = UIAlertController(title: "error".localized(),
                                      message: "paymentFailure".localized(),
                                      preferredStyle: .alert)
        let confirm = UIAlertAction(title: "confirm".localized(),
                                    style: .default,
                                    handler: nil)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentProcessing() {
        chromView.isHidden = false
    }
    
    private func dismissProcesing() {
        chromView.isHidden = true
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
                DispatchQueue.main.async {
                    self.dismissProcesing()
                }
            case .purchasing:
                os_log(.debug, log: .store, "Purchasing - %{PRIVATE}@", transaction.payment.productIdentifier)
            case .purchased:
                os_log(.debug, log: .store, "Purchased - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.dismissProcesing()
                    self.presentPurchaseSuccess()
                }
            case .failed:
                os_log(.error, log: .store, "Failed - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.dismissProcesing()
                    self.presentPurchaseFailure()
                }
            case .restored:
                os_log(.debug, log: .store, "Restored - %{PRIVATE}@", transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.dismissProcesing()
                }
            @unknown default:
                #if DEBUG
                fatalError()
                #endif
                break
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

// MARK: - Collection view
extension TipJarViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard SKPaymentQueue.canMakePayments() == true,
            let product = products?[indexPath.item] else {
                presentPurchaseFailure()
                return
        }
        DispatchQueue.main.async {
            self.presentProcessing()
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.readableContentGuide.layoutFrame.width
        let height: CGFloat
        let sizeCategory = traitCollection.preferredContentSizeCategory
        if sizeCategory == .accessibilityExtraLarge ||
            sizeCategory == .accessibilityExtraExtraLarge ||
            sizeCategory == .accessibilityExtraExtraExtraLarge {
            height = 240
        } else if sizeCategory == .small ||
            sizeCategory == .extraSmall {
            height = 80
        } else {
            height = 100
        }
        return CGSize(width: width, height:  height)
    }
    
    // Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TipItemCell.reuseIdentifier, for: indexPath) as! TipItemCell
        if let product = products?[indexPath.item] {
            cell.populate(product: product)
        }
        return cell
    }
}








class ConfettiView: UIView {
    private lazy var emitterLayer = CAEmitterLayer()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        emitterLayer.frame = bounds
    }
    
    // MARK: - Setup
    private func setup() {
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: -10)
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: 2)
        emitterLayer.frame = bounds
    }
    
    // MARK: - Action
    func startAnimation() {
        emitterLayer.emitterCells = generateCells()
        layer.addSublayer(emitterLayer)
    }
    
    func stopAnimation() {
        emitterLayer.birthRate = 0
    }
    
    // MARK: - Internal
    private func generateCells() -> [CAEmitterCell] {
        return (1...16).map { _ in
            let cell = CAEmitterCell()
            cell.birthRate = 5
            cell.lifetime = 14
            cell.lifetimeRange = 0
            cell.velocity = 200
            cell.velocityRange = 20
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = randomColor()
            cell.contents = randomShape()
            cell.scaleRange = 0.25
            cell.scale = 0.1
            return cell
        }
    }
    
    func randomColor() -> CGColor {
            let colors: [UIColor] = [.systemRed, .systemYellow, .systemBlue, .systemGreen]
            return colors.randomElement()!.cgColor
        }
        
        func randomShape() -> CGImage {
            let images: [UIImage] = [
                 UIImage(named: "Box")!,
                 UIImage(named: "Circle")!,
                 UIImage(named: "Triangle")!
            ]
            return images.randomElement()!.cgImage!
        }
}
