//
//  StoryListInterfaces.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit
enum StoryListDesination {
    case detail(item : Story)
}

protocol StoryListWireframeInterface: WireframeInterface {
    func present(message: String)
    func routeTo(desination : StoryListDesination)
}

protocol StoryListViewInterface: ViewInterface {
    func startLoading()
    func stopLoading()
    func show(viewState : StoryListViewController.ViewState)
}

protocol StoryListPresenterInterface: PresenterInterface {
    var numberOfsection : Int { get }
    func viewDidAppear()
    func didSelect(viewModel: StoryViewModel)
}

protocol StoryListFormatterInterface: FormatterInterface {
    func format(stories : Stories) -> StoryListViewController.ViewState
}

protocol StoryListInteractorInterface: InteractorInterface {
    
    init(worker : TopStoryNetworkManagerProtocol)
    
    func fetch(result: @escaping ((Result<Stories, APIError>) -> Void))
}
