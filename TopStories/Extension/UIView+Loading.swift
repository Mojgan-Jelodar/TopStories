//
//  UIView.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import UIKit
private let loadingTag = Int.max
extension UIView {
    
    func lock() {
        if let activityIndicatorView = viewWithTag(loadingTag) as? UIActivityIndicatorView {
            activityIndicatorView.startAnimating()
        } else {
            let activityIndicatorView = UIActivityIndicatorView(style: .white)
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.tag = loadingTag
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(activityIndicatorView)
            addConstraints([.init(item: activityIndicatorView, attribute: .centerX,
                                  relatedBy: .equal, toItem: self, attribute: .centerX,
                                  multiplier: 1, constant: 0),
                            .init(item: activityIndicatorView, attribute: .centerY,
                                  relatedBy: .equal, toItem: self,
                                  attribute: .centerY, multiplier: 1, constant: 0)])
            activityIndicatorView.startAnimating()
        }
  
    }
    
    func unlock() {
        if let activityIndicatorView = viewWithTag(loadingTag) as? UIActivityIndicatorView {
            activityIndicatorView.stopAnimating()
        }
    }
}
