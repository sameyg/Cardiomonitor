//
//  Graph.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 8/13/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit
import CoreData
import Charts

// Closes viewcontroller and goes back to raw data
class Graph: UIViewController {
    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var graphDates: [Date] = []
    var graphRR: [Int16] = []
//Bar chart!
   
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //There's probs a better way to do this but store dates and rates in array
        
        fetchDataForArrays()
        setChart(dataPoints: graphDates, values: graphRR)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchDataForArrays() {
        
    //This is copied from RateRawData line 65, i should make this a function maybe
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RR")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            for item in fetchedResults {
                graphDates.append(item.value(forKey: "date") as! Date)
                graphRR.append(item.value(forKey: "rrdata") as! Int16)
                print(item.value(forKey: "date")!)
            }
        } catch let error as NSError {
            // something went wrong, print the error.
            print(error.description)
        }
        
    }
    
    func setChart(dataPoints: [Date], values: [Int16]) {
        lineChartView.noDataText = "Add breathing rate data to [Measure resting rate] to get a pretty chart! :)"
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Breathing Rate")
        let chartData = LineChartData(dataSet: chartDataSet)
        self.lineChartView.data = chartData
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




// Graph API Used:

/*
Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/
