//
//  TableViewCell.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//

import UIKit

protocol saveMatchesDelegate: class {
    func saveMatch(_ tag: Int)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
 
    @IBOutlet weak var isSelectedBtn: UIButton!
    
    var cellDelegate: saveMatchesDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    @IBAction func pressBtn(_ sender: UIButton) {
        cellDelegate?.saveMatch(sender.tag)
    }
    
    
}









