//
//  LibraryHeaderView.swift
//  kuStudy
//
//  Created by BumMo Koo on 2020/03/29.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryHeaderView: UICollectionReusableView {
    // MARK: - Data
    private var data: Library! {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()
    
    private lazy var progressView = BigNumberProgressView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionView.clipsToBounds = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleImageValueCell.self,
                                forCellWithReuseIdentifier: TitleImageValueCell.reuseIdentifier)
        collectionView.register(ImageTitleActionCell.self,
                                forCellWithReuseIdentifier: ImageTitleActionCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // MARK: - Setup
    private func setup() {
        
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.leading.equalTo(readableContentGuide.snp.leading)
            make.trailing.equalTo(readableContentGuide.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mainStackView.addArrangedSubview(progressView)
        mainStackView.addArrangedSubview(collectionView)
        
//        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalToSuperview()
            make.height.equalTo(84)
        }
    }
    
    // MARK: - Populate
    func populate(with data: Library) {
        self.data = data
    }
    
    private func reset() {
        
    }
    
    // MARK: - Action
    private func updateView() {
        progressView.populate(progress: data.occupiedPercentage,
                              progressValue: data.occupiedSeats,
                              remainingValue: data.availableSeats)
    }
}

// MARK: - Collection view
extension LibraryHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 2:
            respondingViewController?.presentWebpage(url: data.type.url)
        case 3:
            let cell = collectionView.cellForItem(at: indexPath)
            respondingViewController?.presentShareSheet(activityItems: [data.summary],
                                                        applicationActivities: nil,
                                                        sourceView: cell)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 84)
    }
    
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleImageValueCell.reuseIdentifier, for: indexPath) as! TitleImageValueCell
            cell.populate(title: "laptop".localizedFromKit(),
                          value: data.laptopCapable ? "yes".localizedFromKit() : "no".localizedFromKit(),
                          image: UIImage(systemName: "desktopcomputer"))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleImageValueCell.reuseIdentifier, for: indexPath) as! TitleImageValueCell
            cell.populate(title: "accessible".localizedFromKit(),
                          value: data.accessibleSeats.readable,
                          image: UIImage(systemName: "hand.raised.slash"))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTitleActionCell.reuseIdentifier, for: indexPath) as! ImageTitleActionCell
            cell.populate(title: "viewWeb".localized(),
                          image: UIImage(systemName: "safari"))
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageTitleActionCell.reuseIdentifier, for: indexPath) as! ImageTitleActionCell
            cell.populate(title: "share".localized(),
                          image: UIImage(systemName: "square.and.arrow.up"))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - Context menu
extension LibraryHeaderView {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch indexPath.item {
        case 2:
            let url = data.type.url
            let openInApp = UIAction.presentWebpage(url: url,
                                                    openInApp: true,
                                                    on: respondingViewController)
            let openSafari = UIAction.presentWebpage(url: url,
                                                     openInApp: false,
                                                     on: nil)
            let menu = UIMenu(title: "", children: [openInApp, openSafari])
            return UIContextMenuConfiguration(identifier: nil,
                                       previewProvider: nil)
            { (elements) -> UIMenu? in
                return menu
            }
        case 3:
            let summary = data.summary
            let copy = UIAction.copy(string: summary)
            let share = UIAction.share(string: summary,
                                       presentOn: respondingViewController,
                                       sourceView: collectionView.cellForItem(at: indexPath))
            let menu = UIMenu(title: "", children: [copy, share])
            return UIContextMenuConfiguration(identifier: nil,
                                       previewProvider: nil)
            { (elements) -> UIMenu? in
                return menu
            }
        default:
            return nil
        }
    }
}
