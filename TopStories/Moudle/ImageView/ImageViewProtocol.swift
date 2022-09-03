//
//  ImageViewProtocol.swift
//  TopStories
//
//  Created by Mozhgan on 9/3/22.
//

import Foundation
protocol ImageViewMoudleDelegate : AnyObject {
    func isFinishedWithError(url : String,error : Error)
}
protocol ImageViewPresenterInterface: PresenterInterface {
    func downLoadImage(url : String)
}
protocol ImageViewInteractorInterface: PresenterInterface {
    func download(path: String,completionHandler : @escaping (Result<Data,APIError>) -> Void)
    init(networkSession : APINetworkSession)
}

protocol ImageViewFormatterInterface: FormatterInterface {
    func format(data : Data) -> ImageView.ViewState 
}
protocol ImageViewInterface: ViewInterface {
    func startLoading()
    func stopLoading()
    func show(viewState : ImageView.ViewState )
}
