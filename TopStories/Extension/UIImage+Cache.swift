//
//  ImageCacher.swift
//  TopStories
//
//  Created by Mozhgan on 9/29/22.
//

import Foundation
import UIKit
fileprivate let ImageToCache  : NSCache<NSString,UIImage> = .init()
extension UIImage {

    func download(urlString : String,placeHolder : UIImage,completionHandler : Result<UIImage,Error>) {
        
    }
}


