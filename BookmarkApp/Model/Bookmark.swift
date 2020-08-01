//
//  BMModel.swift
//  BookmarkApp
//
//  Created by 장창순 on 14/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import Foundation

//MARK: - Bookmark

struct Bookmark : Codable {
    private var name : String
    private var url : String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
    
    func getBookmarkName() -> String {
        return name
    }
    
    func getBookmarkURL() -> String {
        return url
    }
}

//MARK: - Direcory

struct Directory: Codable {
    private var name: String
    private var bookmarks: [Bookmark]
    
    init(name: String) {
        self.name = name
        self.bookmarks = [Bookmark]()
    }
    
    func getDirectoryName() -> String {
        return name
    }
    
    func getItems() -> [Bookmark] {
        return bookmarks
    }
    
    func getBookmark(_ index: Int) -> Bookmark {
        return bookmarks[index]
    }
    
    mutating func setDirectoryName(name: String) {
        self.name = name
    }
    
    mutating func deleteBookmark(_ index: Int){
        bookmarks.remove(at: index)
    }
    
    mutating func addBookmark(_ item: Bookmark) {
        bookmarks.append(item)
    }
    
    mutating func setBookmark(_ index: Int, item: Bookmark) {
        bookmarks[index] = item
    }

}
