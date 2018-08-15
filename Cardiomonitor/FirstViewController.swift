//
//  FirstViewController.swift
//  Cardiomonitor
//
//  Created by Samantha Amey-Gonzalez on 7/7/18.
//  Copyright © 2018 RVC. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func segueButtonContactInfo(_ sender: Any) {
        performSegue(withIdentifier: "segueToContactInfo", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

