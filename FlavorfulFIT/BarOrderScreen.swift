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
                descriptionLabel.text = "Decadent bar with coconut and almond flavor profile. Chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams of sugar. Grain free. Take one with water, keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- Pack of 7."
            break
            case 2:
                title = "Berries & Cream"
                descriptionLabel.text = "Sweet vanilla base with a burst of cranberry in every bite. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- Pack of 7."
                barImg.image = UIImage(named: "BerriesnCream")
            break
            case 3:
                title = "Chocolate Peanut Butter"
                descriptionLabel.text = "Delicious fudgey peanut butter bar. Crunchy peanuts and chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- Pack of 7."
                barImg.image = UIImage(named: "ChocoPeanut")
            break
            case 4:
                title = "Chocolate Brownie"
                descriptionLabel.text = "Rich chocolate brownie loaded with chocolate chips and deep cocoa flavor. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- Pack of 7."
            break
            case 5:
                title = "Assorted Chocolate"
                barImg.image = UIImage(named: "AssortedChoco")
            break
            case 6:
                title = "Assorted Vanilla";
                descriptionLabel.text = "Assorted box of vanilla-based FlavorfulFIT Meal Replacement Bars (Coconut Marzipan and Berries & Cream). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- Pack of 7."
                barImg.image = UIImage(named: "AssortedVanilla")
            break
            case 7:
                title = "Sesame Crumb Coating"
                descriptionLabel.text = "Crunchy seasoned grainless 'breadcrumbs' with sesame. Use on anything from chicken, to fish, to veggies. Amazing baked or air fried! One pound container.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- Pack of 7."
                barImg.image = UIImage(named: "CrumbsImg")
            default: title = ""
        }
        self.barTitle.text = title
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    @IBAction func orderButtonPressed(_ sender: Any) {
        if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" {
            submitInfoToGoogleForm(name: nameTF.text!, email: emailTF.text!, phone: phoneTF.text!, packageOrdered: barTitle.text!)
            // Send to paypal form
            // Send to thank you screen
        } else {
            // Alert the bitches to fill out the damn form
        }
    }
    @objc func back() {
        if Singleton.sharedInstance.requestedBarTag < 7 {
            performSegue(withIdentifier: "barOrderToBarSelect", sender: self)
        } else if Singleton.sharedInstance.requestedBarTag == 7 {
            performSegue(withIdentifier: "orderScreenToHome", sender: self)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        back()
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

extension BarOrderScreen {
    func submitInfoToGoogleForm(name: String, email: String, phone: String, packageOrdered: String) {
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSduPIk62Xwzf6gZP_tI4I1L1_u3cdyZw4Se0K_mQgDjXK09ow/formResponse")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "xml")
        request.httpMethod = "POST"
        let postString = "entry.2068669238=\(name)&entry.286274381=\(email)&entry.854835347=\(phone)&entry.39836842=\(packageOrdered)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}

