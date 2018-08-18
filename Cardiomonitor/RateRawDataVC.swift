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
    
    //init stuff for csv export
    
    var cdDate: NSDate?
    var cdRR: Int16!
    
    var fetchedStatsArray: [NSManagedObject] = []
    
    
    @IBAction func exportToCSVButton(_ sender: Any) {
        exportDatabase()
    }
    // Segue to Graph ViewController
  
    
    @IBAction func buttonToGraph(_ sender: Any) {
        performSegue(withIdentifier: "seguetoGraph", sender: self)
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
        //Should be for export
        storeTranscription()
        getTranscriptions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

//Exporting CoreData
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeTranscription() {
        let context = getContext()
        
        /*
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "RR", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context) as! RR
        
        //set the entity values
        transc.date = cdDate
        transc.rrdata = cdRR
        */
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getTranscriptions () {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<RR> = RR.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            fetchedStatsArray = searchResults as [NSManagedObject]
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            //You need to convert to NSManagedObject to use 'for' loops
            for trans in searchResults as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(trans.value(forKey: "rrdata")!)")
                let mdate = trans.value(forKey: "date") as! Date
                print(mdate)
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func exportDatabase() {
        let exportString = createExportString()
        saveAndExport(exportString: exportString)
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "BreathingRateList.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.addToReadingList
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func createExportString() -> String {
        
        
        
        var export: String = NSLocalizedString("Date, RR, \n", comment: "")
        for (index, RR) in fetchedStatsArray.enumerated() {
            if index <= fetchedStatsArray.count - 1 {
                let rrdata = RR.value(forKey: "rrdata")
                let date = RR.value(forKey: "date") as! Date
                export += "\(date),\(rrdata!) \n"
            }
        }
        print("This is what the app will export: \(export)")
        return export
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
