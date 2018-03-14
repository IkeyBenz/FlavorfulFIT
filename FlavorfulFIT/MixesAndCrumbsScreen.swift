//
//  MixesAndCrumbsScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 3/14/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class MixesAndCrumbsScreen: UIViewController {
    
    override func viewDidLoad() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(goHome))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func goToOrderScreen(_ sender: UIButton) {
        Singleton.sharedInstance.requestedBarTag = sender.tag
        performSegue(withIdentifier: "mixesToOrderScreen", sender: self)
    }
    
    @objc func goHome() {
        performSegue(withIdentifier: "mixesToHome", sender: self)
    }
    
}
