//
//  AllMatchesViewController.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//

import UIKit
import CoreData


class noMatchesTableViewCell: UITableViewCell{
    
}
class AllMatcheViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate ,saveMatchesDelegate{
    @NSManaged public var savedMatches: [String]?
    @IBOutlet weak var AllMatchesTableView: UITableView!

        var allMatches: [[String:Any]]?
        var sMatches : [String]?
    
        var savedCoreDataMatches: [String]?


    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupNavbar()
        self.view.showLoader()
                self.AllMatchesTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
                 savedCoreDataMatches = []
                 do {
                          let people = try context.fetch(fetchRequest)
                            for item in people {
                                savedCoreDataMatches?.append(item.value(forKey: "venuesId") as? String ?? "NULL")
                            }
                            self.view.removeLoader()
                        } catch let error as NSError {
                          print("Could not fetch. \(error), \(error.userInfo)")
                        }
    }
  


    override func viewWillAppear(_ animated: Bool) {
        self.view.showLoader()
        Utils.sharedInstance.getAllMatches(completion: { response in
            if let newResponse = response["response"] as? [String: Any]{
                if let getMatches = newResponse["venues"] as? [[String : Any]]{
                    self.allMatches = getMatches
                    self.AllMatchesTableView.reloadData()
                }
                else {
                    self.popupSimpleAlert(title: "Error", message: "Some wrong");
                    self.view.removeLoader()
                }
            }
            else {
                self.popupSimpleAlert(title: "Error", message: "Some wrong");
                self.view.removeLoader()
            }

        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allMatches?.count != 0 && self.allMatches?.count != nil{
            return 10
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.allMatches?.count != 0 && self.allMatches?.count != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let venue = self.allMatches![indexPath.row]
            cell.idLabel.text = (venue["id"] as! String)
            cell.nameLabel.text = (venue["name"] as! String)
            cell.isSelectedBtn.tag = indexPath.row
            cell.selectionStyle = .none
            
            if self.savedCoreDataMatches!.contains((venue["id"] as! String)){
                cell.isSelectedBtn.setImage(UIImage(named: "star1"), for: .normal)
            }
            else {
                cell.isSelectedBtn.setImage(UIImage(named: "star2"), for: .normal)
            }
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noMatchesTableViewCell", for: indexPath) as! noMatchesTableViewCell
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            cell.textLabel?.textAlignment = .center
            let yConstraint = NSLayoutConstraint(item: cell.textLabel!, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: -20)
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if self.allMatches?.count != 0 && self.allMatches?.count != nil {
                return UITableView.automaticDimension
            }
            else {
                return self.AllMatchesTableView.bounds.height
            }
    
        }
      return UITableViewCell()
    }
    
    
    //}
    func saveMatch(_ tag: Int) {
          print("you saved -> ",tag)
        let selectedMatch = self.allMatches![tag]
        let newID = (selectedMatch["id"] as! String)
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "SavedMatches")
        fetchRequest1.predicate = NSPredicate(format: "venuesId = %@", newID)
        let object = try! context.fetch(fetchRequest1)
        if object.count == 0 {
           save(name: newID)
            self.viewDidLoad()
            self.AllMatchesTableView.reloadData()
        }
        do {
            try context.save()
        }
        catch{
            self.popupSimpleAlert(title: "Error", message: "SomeThing went Wrong");
        }
        
    }
    
}
extension AllMatcheViewController {
    func setupNavbar() {


        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        self.navigationController?.navigationBar.backgroundColor = .clear
        let revealViewController = self.revealViewController()

        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "menu2"), for: .normal)
//
        button.addTarget(revealViewController, action:#selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)

        button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
        button.tintColor = .darkGray
        let menuButton = UIBarButtonItem.init(customView: button)
        menuButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        let currHeight = menuButton.customView?.heightAnchor.constraint(equalToConstant: 25)
        currHeight?.isActive = true

        let currWidth = menuButton.customView?.widthAnchor.constraint(equalToConstant: 25)
        currWidth?.isActive = true
        navigationItem.leftBarButtonItem = menuButton
    }
}


