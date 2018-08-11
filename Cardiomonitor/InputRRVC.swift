//
//  SecondViewController.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 7/7/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit

class InputRRVC: UIViewController {
    @IBOutlet weak var timeDate: UILabel!
    var timer = Timer()
    @objc func autoTimeDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        if timeDate != nil{
          timeDate.text = dateFormatter.string(from: Date())
        }
        else{
            print("Time date is nil")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.autoTimeDate) , userInfo: nil, repeats: true)
        autoTimeDate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

