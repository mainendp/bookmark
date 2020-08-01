//
//  DirectoryCell.swift
//  BookmarkApp
//
//  Created by 장창순 on 20/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import UIKit

class DirectoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ item: Directory) {
        nameLabel.text = item.getDirectoryName()
    }
}
