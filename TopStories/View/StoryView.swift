//
//  StoryView.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//

import Foundation
import UIKit

final class StoryView: UIView {
    var configuration: Configuration {
        didSet {
            self.setUpConfiguration()
        }
    }
    
    private lazy var holderView : UIStackView = {
        let holderView = UIStackView(frame: .zero)
        holderView.axis = .horizontal
        holderView.distribution = .fill
        holderView.alignment = .fill
        holderView.spacing = Layout.spacing8
        return holderView
    }()
    
    private lazy var titleLabel : UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: headerLabel.font.pointSize, weight: .bold)
        headerLabel.numberOfLines = .zero
        headerLabel.lineBreakMode = .byWordWrapping
        return headerLabel
    }()
    
    private lazy var iconView : UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        return iconView
    }()
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpViews()
        setUpConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(holderView)
        holderView.addSubview(titleLabel)
        holderView.addSubview(iconView)
        setConstraints()
    }
    
    private func setConstraints() {
       
    }
    
    private func setUpConfiguration() {
        self.titleLabel.text = configuration.viewModel.title
    }
}
extension StoryView {
    struct Configuration {
        let viewModel : StoryViewModel
        
        init(
            viewModel: StoryViewModel
        ) {
            self.viewModel = viewModel
        }
     
    }
}
