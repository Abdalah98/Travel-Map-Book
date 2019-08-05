//
//  MabTableViewController.swift
//  Travel Map Book
//
//  Created by Abdalah on 11/26/1440 AH.
//  Copyright © 1440 AH Abdalah. All rights reserved.
//

import UIKit
import CoreData
class MabTableViewController: UITableViewController {

    var titleArray = [String]()
    var subtitleArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    
    var chosenTitle = ""
    var chosenSubtitle = ""
    var chosenLatitude : Double = 0
    var chosenLongitude : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(MabTableViewController.fetchData), name: NSNotification.Name(rawValue: "newLocationCreated"), object: nil)
    }
    
    @objc func fetchData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                self.titleArray.removeAll(keepingCapacity: false)
                self.subtitleArray.removeAll(keepingCapacity: false)
                self.latitudeArray.removeAll(keepingCapacity: false)
                self.longitudeArray.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    
                    if let subtitle = result.value(forKey: "subtitle") as? String {
                        self.subtitleArray.append(subtitle)
                    }
                    
                    if let latitude = result.value(forKey: "latitude") as? Double {
                        self.latitudeArray.append(latitude)
                    }
                    
                    if let longitude = result.value(forKey: "longitude") as? Double {
                        self.longitudeArray.append(longitude)
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
        } catch {
            print("error")
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        chosenSubtitle = subtitleArray[indexPath.row]
        chosenLatitude = latitudeArray[indexPath.row]
        chosenLongitude = longitudeArray[indexPath.row]
        
        performSegue(withIdentifier: "GoToMab", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToMab" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.transmittedTitle = chosenTitle
            destinationVC.transmittedSubtitle = chosenSubtitle
            destinationVC.transmittedLatitude = chosenLatitude
            destinationVC.transmittedLongitude = chosenLongitude
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
 
    
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "GoToMab", sender: nil)
    }
   
}
