//
//  BookmarkArray.swift
//  BookmarkApp
//
//  Created by 장창순 on 17/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import Foundation

class BookmarkModel {
    
    private var bookmarkArray = [Bookmark]()
    private var directoryArray = [Directory]()
    
    var bookmarkArrayCount : Int {
        get {
            bookmarkArray.count
        }
    }
    
    var directoryArrayCount : Int {
        get {
            directoryArray.count
        }
    }
    
    init() {
        getBookmarkArrayFromUserDefaults()
        getDirectoryArrayFromUserDefaults()
    }
    
    func getSectionCount(index: Int) -> Int {
        if index == SectionType.directory.rawValue {
            return directoryArray.count
        } else {
            return bookmarkArray.count
        }
    }
    
//MARK: - Bookmark Methods
    
    func getBookmarkForPicker(_ at: Int) -> Bookmark? {
        setBookmarkArrayToUserDefaults()
        setDirectoryArrayToUserDefaults()
        if bookmarkArray.count == 0 {
            return nil
        } else {
            return bookmarkArray[at]
        }
    }
    
    func getBookmarkFromBookmarkArray(_ at: Int) -> Bookmark {
        setBookmarkArrayToUserDefaults()
        setDirectoryArrayToUserDefaults()
        return bookmarkArray[at]
    }
    
    func addBookmark(_ name: String, url: String) {
        let bookmark = Bookmark(name: name, url: url)
        self.bookmarkArray.append(bookmark)
        setBookmarkArrayToUserDefaults()
    }
        
    func editBookmarkAt(_ indexpath: Int, name: String, url: String) {
        let bookmark = Bookmark(name: name, url: url)
        bookmarkArray[indexpath] = bookmark
        setBookmarkArrayToUserDefaults()
    }
    
    func deleteBookmarkByIndex(_ index: Int) {
        bookmarkArray.remove(at: index)
        setBookmarkArrayToUserDefaults()
    }

    func setBookmarkArrayToUserDefaults() {
        if let encode = try? JSONEncoder().encode(bookmarkArray) {
            UserDefaults.standard.set(encode, forKey: "bookmark")
        }
    }
    
    func getBookmarkArrayFromUserDefaults() {
        if let savedBookmark = UserDefaults.standard.object(forKey: "bookmark") as? Data {
            if let loadedBookmark = try? JSONDecoder().decode([Bookmark].self, from: savedBookmark) {
                self.bookmarkArray = loadedBookmark
            }
        }
    }
    
//MARK: - Directory methods
    
    func getDirectoryAt(_ at: Int) -> Directory {
        return directoryArray[at]
    }
    
    func getDirectoryName(_ at: Int) -> String {
        return directoryArray[at].getDirectoryName()
    }
    
    func addDirectory(_ name: String) {
        let direcrtory = Directory(name: name)
        directoryArray.append(direcrtory)
        setDirectoryArrayToUserDefaults()
    }
    
    func editDirectoryName(_ indexPath: Int, _ name: String) {
        directoryArray[indexPath].setDirectoryName(name: name)
    }
    
    func appendBookmarkToDirectory(directoryIndex: Int, bookmarkIndex: Int) {
        if bookmarkArray.count == 0 {
            
        } else {
            directoryArray[directoryIndex].addBookmark(bookmarkArray[bookmarkIndex])
            bookmarkArray.remove(at: bookmarkIndex)
            setBookmarkArrayToUserDefaults()
        }
    }
    
    func addBookmarkToDirectory(directoryIndex: Int, bookmark: Bookmark) {
        directoryArray[directoryIndex].addBookmark(bookmark)
        setDirectoryArrayToUserDefaults()
        setBookmarkArrayToUserDefaults()
    }
    
    func deleteBookmarkFromDirectory(directoryIndex: Int, bookmarkIndex: Int) {
        directoryArray[directoryIndex].deleteBookmark(bookmarkIndex)
        setDirectoryArrayToUserDefaults()
    }
    
    func editBookmarkInDirectory(directoryIndex: Int, bookmarkIndex: Int, name: String, url: String) {
        let bookmark = Bookmark(name: name, url: url)
        directoryArray[directoryIndex].setBookmark(bookmarkIndex, item: bookmark)
        setDirectoryArrayToUserDefaults()
    }
    
    func deleteDirectoryByIndex(_ index: Int) {
        for item in directoryArray[index].getItems() {
            bookmarkArray.append(item)
        }
        directoryArray.remove(at: index)
        setDirectoryArrayToUserDefaults()
        setBookmarkArrayToUserDefaults()
    }
    
    func setDirectoryArrayToUserDefaults() {
        if let encode = try? JSONEncoder().encode(directoryArray) {
            UserDefaults.standard.set(encode, forKey: "directory")
        }
    }
    
    func getDirectoryArrayFromUserDefaults() {
        if let savedDirectory = UserDefaults.standard.object(forKey: "directory") as? Data {
            if let loadedDirectory = try? JSONDecoder().decode([Directory].self, from: savedDirectory) {
                self.directoryArray = loadedDirectory
            }
        }
    }
}
