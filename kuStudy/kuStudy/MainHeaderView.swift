//
//  MainHeaderView.swift
//  kuStudy
//
//  Created by BumMo Koo on 05/01/2020.
//  Copyright © 2020 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class MainHeaderView: UICollectionReusableView {
    // MARK: - Data
    private var data = Summary() {
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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold).scaled(for: .subheadline)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        collectionView.clipsToBounds = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleSubtitleValueCell.self,
                                forCellWithReuseIdentifier: TitleSubtitleValueCell.reuseIdentifier)
        collectionView.register(TitleSubtitleValueProgressCell.self,
                                forCellWithReuseIdentifier: TitleSubtitleValueProgressCell.reuseIdentifier)
        collectionView.register(TitleDualSubtitleValueCell.self,
                                forCellWithReuseIdentifier: TitleDualSubtitleValueCell.reuseIdentifier)
        collectionView.register(WeatherConditionCell.self,
                                forCellWithReuseIdentifier: WeatherConditionCell.reuseIdentifier)
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
        updateDate()
        
        let insetValue = readableContentGuide.layoutFrame.origin.x
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: insetValue,
                                                   bottom: 0,
                                                   right: insetValue)
        
        // MARK: - Notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(significantTimeChange:)),
            name: UIApplication.significantTimeChangeNotification,
            object: nil)
    }
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(readableContentGuide.snp.margins)
        }
        
        containerView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    // MARK: - Populate
    func populate(with summary: Summary) {
        data = summary
    }
    
    private func reset() {
        dateLabel.text = nil
    }
    
    // MARK: - Action
    private func updateView() {
        updateDate()
        collectionView.reloadData()
    }
    
    private func updateDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        dateLabel.text = formatter.string(from: Date()).localizedUppercase
    }
    
    // MARK: - Notification action
    @objc
    private func handle(significantTimeChange notification: Notification) {
        updateDate()
    }
}

// MARK: - Collection view
extension MainHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let url = Locale.current.languageCode == "ko" ? URL.academicCalendarURL : URL.academicCalendarURLInternational
            respondingViewController?.presentWebpage(url: url)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat = 90
        switch indexPath.item {
        case 0:
            width = 110
        case 1:
            width = 120
        case 2:
            width = 240
        case 3, 4:
            width = 150
        default:
            width = 0
        }
        return CGSize(width: width, height: height)
    }
    
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubtitleValueCell.reuseIdentifier, for: indexPath) as! TitleSubtitleValueCell
            if let event = AcademicCalendar().currentEvent {
                cell.populate(title: "academicCalendar".localizedFromKit(),
                    subtitle: event.type.name,
                    value: "D-" + event.daysFromToday.readable)
            } else {
                cell.populate(title: "academicCalendar".localizedFromKit(),
                              subtitle: "noEvent".localizedFromKit(),
                              value: "🐯")
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSubtitleValueProgressCell.reuseIdentifier, for: indexPath) as! TitleSubtitleValueProgressCell
            cell.populate(title: "studying".localizedFromKit(),
                          subtitle: "campus.all".localizedFromKit(),
                          value: data.occupiedSeats.readable,
                          progress: data.occupiedPercentage)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleDualSubtitleValueCell.reuseIdentifier, for: indexPath) as! TitleDualSubtitleValueCell
            cell.populate(title: "studying".localizedFromKit(),
                          subtitle1: "campus.liberalArts".localizedFromKit(),
                          value1: data.occupiedSeats(for: LibraryType.liberalArtCampus).readable,
                          progress1: data.occupiedPercentage(for: LibraryType.liberalArtCampus),
                          subtitle2: "campus.science".localizedFromKit(),
                          value2: data.occupiedSeats(for: LibraryType.scienceCampus).readable,
                          progress2: data.occupiedPercentage(for: LibraryType.scienceCampus))
            return cell
//        case 3:
//            let content: (title: String, description: String, value: String) = ("날씨", "놀러가고 싶다", "화창")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionCell.reuseIdentifier, for: indexPath) as! WeatherConditionCell
//            cell.populate(title: content.title, value: content.value, image: UIImage(systemName: "cloud.sun.fill"))
//            return cell
//        case 4:
//            let content: (title: String, description: String, value: String) = ("미세먼지", "콜록콜록", "나쁨")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherConditionCell.reuseIdentifier, for: indexPath) as! WeatherConditionCell
//            cell.populate(title: content.title, value: content.value, image: UIImage(systemName: "cloud.sun.fill"))
//            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - Context menu
extension MainHeaderView {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        switch indexPath.item {
        case 0:
            let content: String
            if let event = AcademicCalendar().currentEvent {
                content = "\(event.type.name) D-\(event.daysFromToday.readable)"
            } else {
                content = "noEvent".localizedFromKit()
            }
            let copy = UIAction.copy(string: content)
            let share = UIAction.share(string: content,
                                       presentOn: respondingViewController,
                                       sourceView: collectionView.cellForItem(at: indexPath))
            let menu = UIMenu(title: "", children: [copy, share])
            return UIContextMenuConfiguration(identifier: nil,
                                              previewProvider: nil)
            { (elements) -> UIMenu? in
                return menu
            }
        case 1, 2:
            let content = """
\("summary.studying.prefix".localized()) \("ku".localizedFromKit())
\("total".localizedFromKit()): \(data.occupiedSeats.readable)
\("campus.liberalArts".localizedFromKit()): \(data.occupiedSeats(for: LibraryType.liberalArtCampus).readable)
\("campus.science".localizedFromKit()): \(data.occupiedSeats(for: LibraryType.scienceCampus).readable)
"""
            let copy = UIAction.copy(string: content)
            let share = UIAction.share(string: content,
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
