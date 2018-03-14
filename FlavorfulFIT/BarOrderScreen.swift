//
//  BarOrderScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/18/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Alamofire

class BarOrderScreen: UIViewController {
    
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var barImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let clientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiIyYzNjMjIxOTU3MjJmMDUwZTNhZDJhNmM2ZTgyY2I4YmFhZDRjNWU3Mzg2ZGZjNTA2NzMwNWU3NzI1ZjAxZGQ0fGNyZWF0ZWRfYXQ9MjAxOC0wMy0wOFQxODo0MDowMi44Njk5NzMxOTQrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0="
    
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
            showDropIn(clientTokenOrTokenizationKey: clientToken)
            submitInfoToGoogleForm(name: nameTF.text!, email: emailTF.text!, phone: phoneTF.text!, packageOrdered: barTitle.text!)
            
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

extension BarOrderScreen {
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "localhost:5000")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
}

