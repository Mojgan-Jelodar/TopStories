//
//  ImageViewFormatter.swift
//  TopStories
//
//  Created by Mozhgan on 9/3/22.
//

import UIKit

extension ImageView {
    enum ViewState {
        case image(image : UIImage)
        case placeHolder
    }
}
final class ImageViewFormatter : ImageViewFormatterInterface {
    func format(data: Data) -> ImageView.ViewState {
        guard let image = UIImage(data: data) else {
            return .placeHolder
        }
        return .image(image: image)
    }
}
