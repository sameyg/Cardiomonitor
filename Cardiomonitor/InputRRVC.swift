//
//  InputRRVC.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 7/7/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit

class InputRRVC: UIViewController {
// time and date
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
   
// submitting new RR to saved data
    
    @IBOutlet weak var breathInput: UITextField!
    @IBOutlet weak var commentInput: UITextView!
    
    @IBAction func addBreathInput(_ sender: Any) {
        if (breathInput.text != "")
        {
        list.append(breathInput.text!)
        }
        else {
            print("You need to put in an actual value")
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
    
    //hide keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

