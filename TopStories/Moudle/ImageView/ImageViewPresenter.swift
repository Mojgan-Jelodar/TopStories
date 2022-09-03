//
//  ImageViewPresenter.swift
//  TopStories
//
//  Created by Mozhgan on 9/3/22.
//

import Foundation
final class ImageViewPresenter {
    unowned private var view : ImageViewInterface
    private var interactor : ImageViewInteractor
    private var formatter : ImageViewFormatterInterface
    weak var delegate : ImageViewMoudleDelegate?
    init(view : ImageViewInterface,
         interactor : ImageViewInteractor,
         formatter : ImageViewFormatterInterface) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
    }
}
extension ImageViewPresenter : ImageViewPresenterInterface {
    func downLoadImage(url: String) {
        self.interactor.download(path: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.view.show(viewState: self.formatter.format(data: data))
            case .failure(let error): break
                self.delegate?.isFinishedWithError(url: url, error: error)
            }
        }
    }
}
