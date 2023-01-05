//
//  SaveMatchesViewController.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//

import UIKit
import CoreData


class SavedMatchesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource ,saveMatchesDelegate {
   @NSManaged public var savedMatches: [String]?
    
    @IBOutlet weak var AllMatchesTableView: UITableView!
   
    var allMatches: [[String:Any]]?
    var sMatches: [String]?
    var filtered: [[String:Any]] = []

    
    var savedCoreDataMatches: [[String:Any]]?
    var savedCoreDataMatchesId: [String]?
    



    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.showLoader()
        self.setupNavbar()
        
        self.AllMatchesTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        savedCoreDataMatchesId = []
        self.filtered = []
        Utils.sharedInstance.getAllMatches(completion: { response in
            if let newResponse = response["response"] as? [String: Any]{
                if let getMatches = newResponse["venues"] as? [[String: Any]] {
                    self.allMatches = getMatches
                    do{
                        let people = try context.fetch(fetchRequest)
                        for item in people {
                            let SaveID = (item.value(forKey: "venueId") as? String ?? "NULL")
                            let filteredDict = self.allMatches!.filter{($0["id"] as? String) ==
                                SaveID}.compactMap{$0}
                            self.filtered.append(filteredDict[0])
                            print("\n\n\n\n NewData ===== >",self.filtered)
                                
                            }
                        self.view.removeLoader()
                    }
                    catch let error as NSError {
                        print("not fetch. \(error), \(error.userInfo)")
                        self.view.removeLoader()
                    }
                    self.AllMatchesTableView.reloadData()
                    }
                else {
                   self.popupSimpleAlert(title: "Error", message: "Something went wrong");
                                      self.view.removeLoader()
                }
                }
            else {
                self.popupSimpleAlert(title: "error", message: "wrong");
            }
            })
            
        }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.filtered.count != 0 {
            return self.filtered.count
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.filtered.count != 0 {
          
                        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as!
                        TableViewCell
                        let venue = self.allMatches![indexPath.row]
                     //   let location = venue["location"] as! [String:Any]
                        cell.idLabel.text = (venue["id"] as! String)
                        cell.nameLabel.text = (venue["name"] as! String)
                        
                        cell.cellDelegate = self
                        cell.isSelectedBtn.tag = indexPath.row
            cell.isSelectedBtn.setImage(UIImage(named: "fillstar"), for: .normal)
            return cell
                      
            //            cell.isSelectedBtn.tag = indexPath.row
            //
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "noMatchesTableViewCell", for: indexPath) as! noMatchesTableViewCell
                        cell.textLabel?.text = "No Matches Availabel"
                        cell.textLabel?.numberOfLines = 0
                        cell.textLabel?.sizeToFit()
                        cell.textLabel?.textAlignment = .center
                        let yConstraint = NSLayoutConstraint(item: cell.textLabel!, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1, constant: -20)
                        self.AllMatchesTableView.addConstraint(yConstraint)
                        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.filtered.count != 0{
            return UITableView.automaticDimension
        }
        else {
            return self.AllMatchesTableView.bounds.height
        }
    }
    func saveMatch(_ tag: Int) {

               print("you saved -> ",tag)
                   let selectedMatch = self.filtered[tag]
                   let newID = (selectedMatch["id"] as! String)
           
           
                   let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "SavedMatches")
                   fetchRequest1.predicate = NSPredicate(format:"venueId = %@", newID)
                   let objects = try! context.fetch(fetchRequest1)
           
                   if objects.count == 0 {
                       save(name: newID)
                       self.viewDidLoad()
                       self.AllMatchesTableView.reloadData()
                   }
                   else {
                       for obj in objects {
                           context.delete(obj)
                           self.viewDidLoad()
                           self.AllMatchesTableView.reloadData()
                       }
                   }
                   do {
                       try context.save() // <- remember to put this :)
                   } catch {
                       self.popupSimpleAlert(title: "Error", message: "Something went wrong");
                   }
               }
       }
        
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



  
//    print("you saved -> ",tag)
//        let selectedMatch = self.allMatches![tag]
//        let newID = (selectedMatch["id"] as! String)
//
//
//        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "SavedMatches")
//        fetchRequest1.predicate = NSPredicate(format:"venueId = %@", newID)
//        let objects = try! context.fetch(fetchRequest1)
//
//        if objects.count == 0 {
//            save(name: newID)
//            self.viewDidLoad()
//            self.AllMatchesTableView.reloadData()
//        }
//        else {
//            for obj in objects {
//                context.delete(obj)
//                self.viewDidLoad()
//                self.AllMatchesTableView.reloadData()
//            }
//        }
//        do {
//            try context.save() // <- remember to put this :)
//        } catch {
//            self.popupSimpleAlert(title: "Error", message: "Something went wrong");
//        }
//    }
extension SavedMatchesViewController {
    func setupNavbar(){
        
                    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                      navigationController?.navigationBar.shadowImage = UIImage()
                      navigationController?.navigationBar.isTranslucent = true
                      navigationController?.view.backgroundColor = .clear
               
               self.navigationController?.navigationBar.backgroundColor = .clear
                      
                      let revealViewController = self.revealViewController()
                      
                      
                      let button = UIButton.init(type: .custom)
                      button.setImage(UIImage.init(named: "menu2"), for: .normal)
                      button.addTarget(revealViewController, action:#selector(SWRevealViewController.revealToggle(_:)), for:.touchUpInside)
                      button.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
                      button.tintColor = .darkGray
                      let menuButton = UIBarButtonItem.init(customView: button)
                      
                      menuButton.customView?.translatesAutoresizingMaskIntoConstraints = false
                      
                      let currWidthmenu = menuButton.customView?.widthAnchor.constraint(equalToConstant: 25)
                      currWidthmenu?.isActive = true
                      let currHeightmenu = menuButton.customView?.heightAnchor.constraint(equalToConstant: 25)
                      currHeightmenu?.isActive = true
                      
                      navigationItem.leftBarButtonItem = menuButton
    }
}
