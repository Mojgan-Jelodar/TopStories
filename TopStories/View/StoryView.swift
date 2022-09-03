//
//  StoryView.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//

import Foundation
import UIKit

fileprivate extension UIImage {
    static let placeHolder = UIImage(named: "PlaceHolder")
}
fileprivate extension Layout {
    static let thumbnailSize : CGSize = CGSize(width: 100, height: 100)
}

final class StoryView: UITableViewCell {
    var configuration: Configuration? {
        didSet {
            self.setUpConfiguration()
        }
    }
    
    private lazy var titleLabel : UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = .systemFont(ofSize: headerLabel.font.pointSize, weight: .bold)
        headerLabel.numberOfLines = .zero
        headerLabel.lineBreakMode = .byWordWrapping
        return headerLabel
    }()
    
    private lazy var iconView : ImageView = {
        let imageView = ImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.setupIconView()
        self.setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: iconView, attribute: .trailing
                                                   , multiplier: 1, constant: Layout.padding8)
        let tarilingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -Layout.padding8)
        let topConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: Layout.padding8)
        let bottomConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Layout.padding8)
        let heightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: iconView, attribute: .height, multiplier: 1, constant: -Layout.padding8)
        self.addConstraints([leadingConstraint, tarilingConstraint, topConstraint, bottomConstraint,heightConstraint])
    }
    
    private func setupIconView() {
        addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Layout.thumbnailSize.width)
        let heightConstraint = NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Layout.thumbnailSize.height)
        let leadingConstraint = NSLayoutConstraint(item: iconView, attribute: .leading, relatedBy: .equal,
                                                   toItem: self, attribute: .leading, multiplier: 1, constant: Layout.padding8)
        let verticalConstraint = NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal,
                                                    toItem: self, attribute: .centerY, multiplier: 1, constant: .zero)
        addConstraints([ widthConstraint, heightConstraint,leadingConstraint,verticalConstraint])
    }
    
    private func setUpConfiguration() {
        self.titleLabel.text = configuration?.viewModel.title
        self.iconView.downLoadImage(url: configuration?.viewModel.largeThumbnailUrl ?? "")
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
