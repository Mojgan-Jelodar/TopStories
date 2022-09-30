//
//  StoryListFormatter.swift
//  TopStories
//
//  Created by Mozhgan on 8/30/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class StoryListFormatter {
}

// MARK: - Extensions -

extension StoryListFormatter: StoryListFormatterInterface {
    func format(story: Story,isBookmarked : Bool) -> StoryCellViewModel {
        return StoryCellViewModel(title: story.title ?? "",
                                  largeThumbnailUrl: thumbail(story: story),
                                  isBookmarked: isBookmarked)
    }
    
    private func thumbail(story : Story) -> Multimedia? {
        guard let largeThumbnail = story.multimedia?.first(where: {$0.format == .largeThumbnail}) else {
            return nil
        }
        return largeThumbnail
    }
}

extension StoryListViewController {
    enum ViewState : Equatable {
        case loaded
        case emptyState
    }
}

struct StoryCellViewModel: Equatable {
    static func == (lhs: StoryCellViewModel, rhs: StoryCellViewModel) -> Bool {
        lhs.title == rhs.title
    }
    
    let title : String
    let largeThumbnailUrl : Multimedia?
    let isBookmarked : Bool
}
