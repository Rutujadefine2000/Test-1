//
//  menuTableViewController.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell{
    
}

class MenuTableViewCell: UITableViewCell{
    
}

class menuTableViewController: UITableViewController {
    
       var menuOption: [String] = ["All Matches", "Saved Matches"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 3
     }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
                    cell.selectionStyle = .none
                    return cell
    }
           else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
                    cell.textLabel?.text = menuOption[indexPath.row - 1]
                    cell.selectionStyle = .none
                    return cell
                }

              }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "toAllMatches", sender: self)
            
        }
        else if indexPath.row == 2 {
            self.performSegue(withIdentifier: "toSavedMatches", sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else {
            return 50
        }
    }
    

}





