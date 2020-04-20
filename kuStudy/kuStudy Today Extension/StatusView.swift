//
//  StatusView.swift
//  kuStudy Today Extension
//
//  Created by BumMo Koo on 2017. 8. 4..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import UIKit
import SnapKit

class StatusView: UIView {
    // MARK: - State
    enum State {
        case loading
        case success
        case error(Error?)
    }
    
    var state: State = .loading {
        didSet {
            updateView()
        }
    }
    
    // MARK: - View
    private lazy var vibracyView: UIVisualEffectView = {
        let effect = UIVibrancyEffect.widgetEffect(forVibrancyStyle: .secondaryLabel)
        return UIVisualEffectView(effect: effect)
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "error.general".localized()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
        updateViewForLoading()
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        addSubview(vibracyView)
        vibracyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        vibracyView.contentView.addSubview(activityIndicator)
        vibracyView.contentView.addSubview(descriptionLabel)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Action
    private func updateView() {
        switch state {
        case .loading:
            updateViewForLoading()
        case .success:
            updateViewForSuccess()
        case let .error(error):
            updateViewForError(error?.localizedDescription)
        }
    }
    
    private func updateViewForLoading() {
        isHidden = false
        activityIndicator.startAnimating()
        descriptionLabel.isHidden = true
    }
    
    private func updateViewForSuccess() {
        isHidden = true
        activityIndicator.stopAnimating()
        descriptionLabel.isHidden = true
    }
    
    private func updateViewForError(_ message: String?) {
        isHidden = false
        activityIndicator.stopAnimating()
        descriptionLabel.isHidden = false
    }
}
