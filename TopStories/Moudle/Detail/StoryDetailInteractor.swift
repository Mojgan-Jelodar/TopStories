//
//  StoryDetailInteractor.swift
//  TopStories
//
//  Created by Mozhgan on 9/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class StoryDetailInteractor : StoryDetailInteractorInterface {
    var stroy: Story
    init(story : Story) {
        self.stroy = story
    }
}