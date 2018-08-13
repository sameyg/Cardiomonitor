//
//  RateRawDataVC.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 8/11/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit
import CoreData


class RateRawDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
// Segue to Graph ViewController
    @IBAction func segueButtontoGraph(_ sender: Any) {
        performSegue(withIdentifier: "RawtoGraph", sender: self)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (rrCD.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "RRCell")
        //make stuff in CoreData Strings for cells
        let rrWut: Int = rrCD[indexPath.row].value(forKey: "rrdata") as! Int
        let rrString = String(rrWut)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        
        let rrDate: Date = rrCD[indexPath.row].value(forKey: "date") as! Date
        let dateString = dateFormatter.string(from: rrDate)
        
        cell.textLabel?.text = "\(dateString), \(rrString)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            rrCD.remove(at: indexPath.row)
//Delete from CoreData as well!
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
//Copied from Fetching CoreData line (81 at time of this)
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RR")
            do {
                let removeThisRR = try managedContext.fetch(fetchRequest)
                managedContext.delete(removeThisRR[indexPath.row])
                
                try managedContext.save()
            }
            catch {
                print("big oopsies")
            }
            rawDataTable.reloadData()
        }
    }

    @IBOutlet weak var rawDataTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        rawDataTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

// Fetching CoreData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RR")
        
        //3
        do {
            rrCD = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
