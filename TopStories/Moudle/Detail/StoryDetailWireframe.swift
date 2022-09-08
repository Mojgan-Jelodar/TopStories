//
//  StoryDetailWireframe.swift
//  TopStories
//
//  Created by Mozhgan on 9/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class StoryDetailWireframe: BaseWireframe<StoryDetailViewController> {

    // MARK: - Private properties -

    // MARK: - Module setup -

    init(story : Story) {
        let moduleViewController = StoryDetailViewController(nibName: nil, bundle: nil)
        super.init(viewController: moduleViewController)
        let formatter = StoryDetailFormatter()
        let interactor = StoryDetailInteractor(story: story)
        let presenter = StoryDetailPresenter(view: moduleViewController, formatter: formatter, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension StoryDetailWireframe: StoryDetailWireframeInterface {
    func present(request: URLRequest) {
        self.viewController.presentWireframe(WebWireframe(urlRequest: request))
    }
    
}
