//
//  Strings.swift
//  TopStories
//
//  Created by Mozhgan on 9/5/22.
//

import Foundation
enum Strings {}
extension Strings {
    enum StoryListView {
        static let pageTitle = "STORIES_LIST_TITLE".localiz()
        static let refreshingString = "PULL_TO_REFRESH".localiz()
    }

    enum CommonStrings {
        static let alertTitle = "ALERT".localiz()
        static let ok = "OK".localiz()
        static let emptyState = "THERE_IS_NO_ITEM_TO_DISPLAY".localiz()
    }
}
fileprivate extension String {
    
    ///
    /// Localize the current string to the selected language
    ///
    /// - returns: The localized string
    ///
    func localiz(comment: String = "") -> String {
        guard let bundle = Bundle.main.path(forResource: Bundle.main.preferredLocalizations.first, ofType: "lproj") else {
            return NSLocalizedString(self, comment: comment)
        }
        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: comment)
    }
}
