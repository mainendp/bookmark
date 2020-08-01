//
//  DirectoryTableViewController.swift
//  BookmarkApp
//
//  Created by 장창순 on 21/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import UIKit

class DirectoryTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, BookmarkAccessable {
    
    @IBOutlet weak var getBookmarkLabel: UIBarButtonItem!
    private var indexpath = 0
    private var bookmarkModel: BookmarkModel!
    
    private var pickerView = UIPickerView()
    private var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = bookmarkModel.getDirectoryName(indexpath)
        getBookmarkLabel.title = "가져오기"
        AdmobController.setupBannerView(toViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkModel.getDirectoryAt(indexpath).getItems().count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeCell = UIContextualAction(style: .destructive, title: "삭제") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.bookmarkModel.deleteBookmarkFromDirectory(directoryIndex: self.indexpath, bookmarkIndex: indexPath.row)
            self.tableView.reloadData()
        }
        
        let editCell = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.performSegue("editDirectoryBookmarkSegue", indexPath.row)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [removeCell, editCell])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bookmarkCell = BookmarkCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookmarkCell {
            bookmarkCell = cell
        }
        bookmarkCell.update(bookmarkModel.getDirectoryAt(indexpath).getBookmark(indexPath.row))
        return bookmarkCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = bookmarkModel.getDirectoryAt(indexpath).getBookmark(indexPath.row).getBookmarkURL()
        
        let alert = UIAlertController(title: nil, message: "URL이 복사 되었습니다.", preferredStyle: .alert)
        
        present(alert, animated:true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    //MARK: - UIPicker View data source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        bookmarkModel.bookmarkArrayCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bookmarkModel.getBookmarkForPicker(row)?.getBookmarkName()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bookmarkModel.appendBookmarkToDirectory(directoryIndex: indexpath, bookmarkIndex: row)
        alert.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    @IBAction func GetBookmarkWithNoDirectoryButtonPressed(_ sender: Any) {
              
        alert = UIAlertController(title: "이동할 북마크를 선택해 주세요.", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
              
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: view.frame.size.width - 16 , height: 130))
        alert.view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @IBAction func addBookmarkButtonPressed(_ sender: UIBarButtonItem) {
      
      var nameTextfield = UITextField()
      var urlTextfield = UITextField()
      
      let alert = UIAlertController(title: "북마크 추가", message: nil, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "취소", style: .destructive)
      let addAction = UIAlertAction(title: "저장", style: .default) { (action) in
          if (nameTextfield.text != "") && (urlTextfield.text != "") {
              if let name = nameTextfield.text , let url = urlTextfield.text {
                let bookmark = Bookmark(name: name, url: url)
                self.bookmarkModel.addBookmarkToDirectory(directoryIndex: self.indexpath, bookmark: bookmark)
                self.tableView.reloadData()
              }
          } else {
            AlertController.alert(type: AlertType.TextfieldCanBeNull, withViewController: self)
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

    func setBookmarkModel(_ bookmark: BookmarkModel, withIndex index: Int) {
        bookmarkModel = bookmark
        indexpath = index
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sender as? Int, let editCell = segue.destination as? DirectoryBookmakrViewController {
            editCell.setBookmarkModel(bookmarkModel, withIndex: indexpath)
            editCell.setCellIndexPath(index)
        }
    }
}
