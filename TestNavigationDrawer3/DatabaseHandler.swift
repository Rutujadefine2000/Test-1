//
//  DatabaseHandler.swift
//  TestNavigationDrawer3
//
//  Created by Brahmastra on 20/12/22.
//  Copyright © 2022 Brahmastra. All rights reserved.
//

import CoreData
import UIKit
import ARSLineProgress
import Alamofire





let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedMatches")

func save(name: String){
  
guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    let managedContext = appDelegate.persistentContainer.viewContext

    let entity = NSEntityDescription.entity(forEntityName: "SavedMatches", in: managedContext)!

    let person = NSManagedObject(entity: entity, insertInto: managedContext)

    person.setValue(name, forKey: "venueId")

    do{
        try managedContext.save()
    }
    catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")

    }
    }
func deleteAllData(_ entity:String) {
    let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: entity)
    let objects = try! context.fetch(fetchRequest1)
    for obj in objects {
        context.delete(obj)
    }
    do {
        try context.save() // <- remember to put this :)
    } catch {
        print("Something went wrong");
    }
}

extension UIView{
    func showLoader(){

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        ARSLineProgress.ars_showOnView(blurEffectView.contentView)
        self.addSubview(blurEffectView)
    }

    func removeLoader(){
        //           self.subviews.compactMap{}
        DispatchQueue.main.async( execute: {
            self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
                ARSLineProgress.hide()
                $0.removeFromSuperview()
            }

        })


    }
}
extension UIViewController {
    func popupSimpleAlert(title: String?, message: String?) -> () {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class customView: UIView {
    @IBInspectable var makeRoundedView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
