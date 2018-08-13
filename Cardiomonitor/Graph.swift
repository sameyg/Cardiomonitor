//
//  Graph.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 8/13/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit
import CoreData

// Closes viewcontroller and goes back to raw data
class Graph: UIViewController {
    @IBAction func onCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
