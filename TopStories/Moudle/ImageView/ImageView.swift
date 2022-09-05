//
//  ImageView.swift
//  TopStories
//
//  Created by Mozhgan on 9/3/22.
//

import UIKit

fileprivate extension UIImage {
    static let placeHolder = UIImage(named: "PlaceHolder")
}
final class ImageView: UIView {
    private lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = .placeHolder
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var presenter : ImageViewPresenter = {
        return ImageViewPresenter.init(view: self,
                                       interactor: self.interactor,
                                       formatter: formatter)
    }()
    private lazy var interactor : ImageViewInteractor = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        let networkSession = APINetworkSession(configuration: .default, delegateQueue: operationQueue)
        return ImageViewInteractor(networkSession: networkSession)
    }()
    private lazy var formatter : ImageViewFormatter = {
        let formatter = ImageViewFormatter()
        return formatter
    }()
    
    required init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView() {
        self.setupImageView()
        self.setupLoadingView()
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leadingMargin, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: .zero)
        let tarilingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailingMargin, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: .zero)
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: .topMargin, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: .zero)
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottomMargin, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: .zero)
        self.addConstraints([leadingConstraint, tarilingConstraint, topConstraint, bottomConstraint])
    }
    
    private func setupLoadingView() {
        self.addSubview(activityIndicator)
        let centerXConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: .zero)
        let centerYConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: .zero)
        self.addConstraints([centerXConstraint, centerYConstraint])
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    func downLoadImage(url: String) {
        self.presenter.downLoadImage(url: url)
    }
    
}
extension ImageView : ImageViewInterface {
    func show(viewState: ImageView.ViewState) {
        switch viewState {
        case .image(image: let image):
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.image = image
        case .placeHolder:
            self.imageView.image = UIImage.placeHolder
        }
    }
    
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
    }
}
