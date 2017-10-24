//
//  LibraryTableViewCell.swift
//  kuStudy
//
//  Created by 구범모 on 2015. 5. 31..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit
import kuStudyKit

class LibraryTableViewCell: UITableViewCell {
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var dataStackView: UIStackView!
    @IBOutlet private weak var availablePlaceholderLabel: UILabel!
    @IBOutlet private weak var totalPlaceholderLabel: UILabel!
    @IBOutlet private weak var usedPlaceholderLabel: UILabel!
    
    @IBOutlet private weak var availableLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var usedLabel: UILabel!
    
    private var data: LibraryData?

    // MARK: View
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setEmpty()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = indicatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        indicatorView.backgroundColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = indicatorView.backgroundColor
        super.setSelected(selected, animated: animated)
        indicatorView.backgroundColor = color
    }
    
    // MARK: UI
    private func setup() {
        indicatorView.layer.cornerRadius = indicatorView.bounds.width / 2
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
        
        if #available(iOS 11.0, *) {
            indicatorView.accessibilityIgnoresInvertColors = true
            thumbnailImageView.accessibilityIgnoresInvertColors = true
        }
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleShouldUpdateImage(_:)), name: MediaManager.shouldUpdateImageNotification, object: nil)
    }
    
    func updateInterface(for traitCollectoin: UITraitCollection) {
        if traitCollection.preferredContentSizeCategory == .accessibilityLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraLarge ||
            traitCollection.preferredContentSizeCategory == .accessibilityExtraExtraExtraLarge {
            bottomStackView.axis = .vertical
            dataStackView.axis = .vertical
        } else {
            bottomStackView.axis = .horizontal
            dataStackView.axis = .horizontal
        }
    }
    
    // MARK: - Notification
    @objc private func handleShouldUpdateImage(_ notification: Notification) {
        guard let data = data else { return }
        UIView.transition(with: thumbnailImageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.thumbnailImageView.image = data.media?.thumbnail
            }, completion: nil)
    }
    
    // MARK: Populate
    private func setEmpty() {
        thumbnailImageView.image = nil
        nameLabel.text = Localizations.Common.NoData
        availablePlaceholderLabel.text = Localizations.Common.Available
        totalPlaceholderLabel.text = Localizations.Common.Total
        usedPlaceholderLabel.text = Localizations.Common.Used
        availableLabel.text = Localizations.Common.NoData
        totalLabel.text = Localizations.Common.NoData
        usedLabel.text = Localizations.Common.NoData
        indicatorView.backgroundColor = UIColor.lightGray
    }
    
    func populate(library data: LibraryData?) {
        self.data = data
        guard let data = data else {
            setEmpty()
            return
        }
        guard let library = data.libraryType else {
            setEmpty()
            return
        }
        
        nameLabel.text = library.name
        availableLabel.text =  data.available.readable
        totalLabel.text = data.total.readable
        usedLabel.text = data.occupied.readable
        
        thumbnailImageView.image = data.media?.thumbnail
        indicatorView.backgroundColor = data.availablePercentageColor
    }
}
