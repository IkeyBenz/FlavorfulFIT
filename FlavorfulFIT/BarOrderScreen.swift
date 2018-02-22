//
//  BarOrderScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/18/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class BarOrderScreen: UIViewController {
    
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var barImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(moveScreenUp), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(moveScreenDown), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        barImg.contentScaleFactor = CGFloat(UIViewContentMode.scaleAspectFill.rawValue)
        let tag = Singleton.sharedInstance.requestedBarTag!
        var title = ""
        switch tag {
            case 1:
                title = "Coconut Marzipan"
                descriptionLabel.text = "Decadent bar with coconut and almond flavor profile. Chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams of sugar. Grain free. Take one with water, keep frozen.\n*Contains tree nuts. Processed on equipment that handles peanuts. Certified Kosher Parve. Pack of 7."
            break
            case 2:
                title = "Berries & Cream"
                barImg.image = UIImage(contentsOfFile: "BerriesnCream")
            break
            case 3:
                title = "Chocolate Peanut Butter"
                barImg.image = UIImage(contentsOfFile: "ChocoPeanut")
            break
            case 4:
                title = "Chocolate Brownie"
            break
            case 5:
                title = "Assorted Chocolate"
                barImg.image = UIImage(contentsOfFile: "AssortedChoco")
            break
            case 6:
                title = "Assorted Vanilla";
                barImg.image = UIImage(contentsOfFile: "AssortedVanilla")
            break
            default: title = ""
        }
        self.barTitle.text = title
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    @objc func back() {
        performSegue(withIdentifier: "barOrderToBarSelect", sender: self)
    }
    
    @objc func moveScreenUp() {
        self.view.frame.origin.y = -300
    }
    
    @objc func moveScreenDown() {
        self.view.frame.origin.y = 0
    }
}

extension BarOrderScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            emailTF.becomeFirstResponder()
        } else if textField.tag == 2 {
            phoneTF.becomeFirstResponder()
        } else if textField.tag == 3 {
            phoneTF.resignFirstResponder()
        }
        return true
    }
}

