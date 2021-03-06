//
//  BarsScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/15/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class BarsScreen: UIViewController {
    
    @IBOutlet weak var ccntMarzpan: UIButton!
    @IBOutlet weak var berriescream: UIButton!
    @IBOutlet weak var chcoPeanut: UIButton!
    @IBOutlet weak var chocoBrownie: UIButton!
    @IBOutlet weak var assortedChoco: UIButton!
    @IBOutlet weak var assortedVanilla: UIButton!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var optionsStackAspect: NSLayoutConstraint!
    
    override func viewDidLoad() {
        let buttons = [ccntMarzpan, berriescream, chcoPeanut, chocoBrownie, assortedChoco, assortedVanilla]
        var tagNumber = 0
        for button in buttons {
            tagNumber += 1
            button?.tag = tagNumber
            button?.titleLabel?.numberOfLines = 0
            button?.titleLabel?.textAlignment = .center
            button?.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            button?.imageView?.clipsToBounds = true
        }
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)

        if UIScreen.main.bounds.height - optionsStackView.frame.maxY < 0 {
            optionsStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            optionsStackAspect = nil
        }
    }
    
    @objc func back() {
        performSegue(withIdentifier: "homeSegue", sender: self)
    }
    @IBAction func goToBarOrderScreen(_ sender: UIButton) {
        Singleton.sharedInstance.requestedBarTag = sender.tag
        performSegue(withIdentifier: "segue", sender: self)
    }
    
}
