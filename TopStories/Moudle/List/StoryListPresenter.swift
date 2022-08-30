//
//  StoryListPresenter.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class StoryListPresenter {

    // MARK: - Private properties -

    private unowned let view: StoryListViewInterface
    private let formatter: StoryListFormatterInterface
    private let interactor: StoryListInteractorInterface
    private let wireframe: StoryListWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: StoryListViewInterface,
        formatter: StoryListFormatterInterface,
        interactor: StoryListInteractorInterface,
        wireframe: StoryListWireframeInterface
    ) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension StoryListPresenter: StoryListPresenterInterface {
}
