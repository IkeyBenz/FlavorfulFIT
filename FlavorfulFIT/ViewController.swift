//
//  ViewController.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/15/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func crumbsScreenClicked(_ sender: Any) {
        Singleton.sharedInstance.requestedBarTag = 7
    }
    
}

