//
//  ProgramsScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/15/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class ProgramsScreen: UIViewController {
    
    override func viewDidLoad() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(goHome))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func goHome() {
        performSegue(withIdentifier: "programsToHome", sender: self)
    }
    
    @IBAction func goToOrderScreen(_ sender: UIButton) {
        Singleton.sharedInstance.requestedBarTag = sender.tag
        performSegue(withIdentifier: "programsToOrderScreen", sender: self)
    }
    
}
