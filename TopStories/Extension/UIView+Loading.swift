//
//  UIView.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import UIKit
extension UIView {
    fileprivate static let loadingTag = Int.max
    func lock() {
        guard viewWithTag(UIView.loadingTag) == nil else {
            return
        }
        let activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.tag = UIView.loadingTag
        addSubview(activityIndicatorView)
        center = activityIndicatorView.center
        activityIndicatorView.startAnimating()
    }

    func unlock() {
        if let activityIndicatorView = viewWithTag(UIView.loadingTag) as? UIActivityIndicatorView {
            activityIndicatorView.stopAnimating()
        }
    }
}

