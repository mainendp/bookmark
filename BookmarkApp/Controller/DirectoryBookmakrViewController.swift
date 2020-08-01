//
//  DirectoryBookmakrViewController.swift
//  BookmarkApp
//
//  Created by 장창순 on 22/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import UIKit

class DirectoryBookmakrViewController: UIViewController, BookmarkAccessable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var urlTextfield: UITextField!
    
    private var indexpath = 0
    private var cellIndexPath = 0
    
    private var bookmarkModel: BookmarkModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "이름"
        urlLabel.text = "URL"
        okButton.setTitle("확인", for: .normal)
        
        nameTextfield.text = bookmarkModel.getDirectoryAt(indexpath).getBookmark(cellIndexPath).getBookmarkName()
        urlTextfield.text = bookmarkModel.getDirectoryAt(indexpath).getBookmark(cellIndexPath).getBookmarkURL()
        AdmobController.setupBannerView(toViewController: self)
    }
    
    func setBookmarkModel(_ bookmark: BookmarkModel, withIndex index: Int) {
        bookmarkModel = bookmark
        indexpath = index
    }
    
    func setCellIndexPath(_ index: Int) {
        cellIndexPath = index
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        if (nameTextfield.text == "") || (urlTextfield.text == "") {
            let notice = UIAlertController(title: nil, message: "모든 텍스트 필드를 입력해주세요.", preferredStyle: .alert)
            present(notice, animated:true)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if let name = nameTextfield.text , let url = urlTextfield.text {
                bookmarkModel.editBookmarkInDirectory(directoryIndex: indexpath, bookmarkIndex: cellIndexPath, name: name, url: url)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
