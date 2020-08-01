//
//  BMTableVC.swift
//  BookmarkApp
//
//  Created by 장창순 on 11/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import UIKit

enum SectionType: Int {
    case directory
    case bookmark
}

class BookmarkTableViewController: UITableViewController {
    
    var bookmarkModel = BookmarkModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "북마크"
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        AdmobController.setupBannerView(toViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkModel.getSectionCount(index: section)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeCell = UIContextualAction(style: .destructive, title: "삭제") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.onRemoveActionByIndexPath(indexPath)
        }
        return self.onEditActionByIndexPath(indexPath: indexPath, action: removeCell)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellTypeByIndexPath(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowByIndex(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func AlertYouNeedName() {
    }
    
    @IBAction func addDirectoryButtonPressed(_ sender: Any) {
        
        var nameTextField = UITextField()
        
        let alert = UIAlertController(title: "폴더 생성", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        let addAction = UIAlertAction(title: "생성", style: .default) { (action) in
            if nameTextField.text == "" {
                return;
            }
            
            if let name = nameTextField.text {
                self.bookmarkModel.addDirectory(name)
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertNameTextfield) in
            alertNameTextfield.placeholder = "디렉토리의 이름을 입력해 주세요."
            nameTextField = alertNameTextfield
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func addBookmarkButtonPressed(_ sender: UIBarButtonItem) {
        
        var nameTextfield = UITextField()
        var urlTextfield = UITextField()
        
        let alert = UIAlertController(title: "북마크 추가", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        let addAction = UIAlertAction(title: "저장", style: .default) { (action) in
            if (nameTextfield.text == "") || (urlTextfield.text == "") {
                let notice = UIAlertController(title: nil, message: "모든 텍스트 필드를 입력해주세요.", preferredStyle: .alert)
                self.present(notice, animated:true)
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    self.dismiss(animated: true, completion: nil)
                    self.present(alert, animated:true)
                }
            }
            else if let name = nameTextfield.text , let url = urlTextfield.text {
                self.bookmarkModel.addBookmark(name, url: url)
                self.tableView.reloadData()
            }
        }

        alert.addTextField { (alertNameTextfield) in
            alertNameTextfield.placeholder = "북마크 이름을 입력해 주세요."
            nameTextfield = alertNameTextfield
        }
        
        alert.addTextField { (alertURLTextfield) in
            alertURLTextfield.placeholder = "URL을 입력해 주세요."
            if let copiedText = UIPasteboard.general.string {
            alertURLTextfield.text = copiedText
            }
            urlTextfield = alertURLTextfield
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookmarkAccessor = segue.destination as? BookmarkAccessable {
            if let index = sender as? Int {
                bookmarkAccessor.setBookmarkModel(bookmarkModel, withIndex: index)
            }
        }
    }
    
    //MARK: - TableView Swipe Methods
    private func onRemoveActionByIndexPath(_ indexPath: IndexPath) {
        if indexPath.section == SectionType.directory.rawValue {
            self.bookmarkModel.deleteDirectoryByIndex(indexPath.row)
        } else {
            self.bookmarkModel.deleteBookmarkByIndex(indexPath.row)
        }
        self.tableView.reloadData()
    }
    
    private func onEditActionByIndexPath(indexPath: IndexPath, action: UIContextualAction) -> UISwipeActionsConfiguration {
        if indexPath.section == SectionType.directory.rawValue {
            let editCell = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction, UIView, (Bool) -> Void) in
                var nameTextField = UITextField()
                let alert = UIAlertController(title: "폴더 이름 변경", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
                }
                let addAction = UIAlertAction(title: "저장", style: .default) { (action) in
                    if nameTextField.text != "" {
                        if let name = nameTextField.text {
                            self.bookmarkModel.editDirectoryName(indexPath.row, name)
                            self.tableView.reloadData()
                        }
                    }
                }
                alert.addTextField { (alertNameTextfield) in
                    alertNameTextfield.placeholder = "디렉토리의 이름을 입력해 주세요."
                    nameTextField = alertNameTextfield
                }
                alert.addAction(cancelAction)
                alert.addAction(addAction)
                self.present(alert, animated: true)
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [action, editCell])
            swipeAction.performsFirstActionWithFullSwipe = false
            return swipeAction
        } else {
            let editCell = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.performSegue("editBookmarkSegue", indexPath.row)
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [action, editCell])
            swipeAction.performsFirstActionWithFullSwipe = false
            return swipeAction
        }
    }
    
    private func cellTypeByIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.directory.rawValue {
            var directoryCell = DirectoryCell()
            if let cell = tableView.dequeueReusableCell(withIdentifier: "directoryCell", for: indexPath) as? DirectoryCell {
                directoryCell = cell
            }
            directoryCell.update(bookmarkModel.getDirectoryAt(indexPath.row))
            return directoryCell
        } else {
            var bookmarkCell = BookmarkCell()
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookmarkCell {
                bookmarkCell = cell
            }
            bookmarkCell.update(bookmarkModel.getBookmarkFromBookmarkArray(indexPath.row))
            return bookmarkCell
        }
    }
    
    private func selectedRowByIndex(_ indexPath: IndexPath) {
        if indexPath.section == SectionType.directory.rawValue {
            self.performSegue(withIdentifier: "directorySegue", sender: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            UIPasteboard.general.string = bookmarkModel.getBookmarkFromBookmarkArray(indexPath.row).getBookmarkURL()
            AlertController.alert(type: .CopiedBookmark, withViewController: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
