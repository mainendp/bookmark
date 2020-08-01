//
//  BookmarkAccessable.swift
//  BookmarkApp
//
//  Created by Cody on 2020/02/25.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import Foundation

protocol BookmarkAccessable {
    func setBookmarkModel(_ bookmark: BookmarkModel, withIndex index: Int)
}
