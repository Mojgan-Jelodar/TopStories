//
//  UIImageView+LoadImageNetwork.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import UIKit
import OSLog

extension UIImageView {
    func loadImageFrom(urlString : String,
                       placeHolder : UIImage? = nil) {
        
        self.image = placeHolder
        self.lock()
        UIImage.loadImageFrom(urlString: urlString,
                                  completionHandler: { [weak self] result in
            self?.unlock()
            switch result {
            case .success(let image):
                self?.image = image
            case .failure(let error) :
                os_log("Error: %@", log: .default, type: .error, String(describing: error))
            }
        })
    }
}
