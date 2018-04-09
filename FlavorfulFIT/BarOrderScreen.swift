//
//  BarOrderScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/18/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree
import Alamofire

class BarOrderScreen: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var formContainer: UIStackView!
    @IBOutlet weak var formContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    
    
    var clientToken: String!
    var braintreeClient: BTAPIClient!
    var price: Double!
    
    func showExtraCredentials() {
        heightStackView.isHidden = false
        weightStackView.isHidden = false
        formContainerHeight.constant = 130
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        if Singleton.sharedInstance.requestedBarTag == 9 || Singleton.sharedInstance.requestedBarTag == 10 {
            showExtraCredentials()
            print("I wonder if this looks like garbage")
            print("Hey future Ikey, does this look like garbage?")
        }
        fetchClientToken()
        productImageView.contentScaleFactor = CGFloat(UIViewContentMode.scaleAspectFit.rawValue)
        let tag = Singleton.sharedInstance.requestedBarTag!
        var title = ""
        switch tag {
            case 1:
                title = "Coconut Marzipan"
                descriptionLabel.text = "Decadent bar with coconut and almond flavor profile. Chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams of sugar. Grain free. Take one with water, keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "CoconutMarzipan")
                price = 15.00
            break
            case 2:
                title = "Berries & Cream"
                descriptionLabel.text = "Sweet vanilla base with a burst of cranberry in every bite. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "BerriesnCream")
                price = 15.00
            break
            case 3:
                title = "Chocolate Peanut Butter"
                descriptionLabel.text = "Delicious fudgey peanut butter bar. Crunchy peanuts and chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "ChocoPeanut")
                price = 15.00
            break
            case 4:
                title = "Chocolate Brownie"
                descriptionLabel.text = "Rich chocolate brownie loaded with chocolate chips and deep cocoa flavor. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "ChocoBrownie")
                price = 15.00
            break
            case 5:
                title = "Assorted Chocolate"
                descriptionLabel.text = "Assorted box of chocolate-based FlavorfulFIT Meal Replacement Bars (Chocolate Peanut Butter and Chocolate Brownie). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "AssortedChocolate")
                price = 15.00
            break
            case 6:
                title = "Assorted Vanilla";
                descriptionLabel.text = "Assorted box of vanilla-based FlavorfulFIT Meal Replacement Bars (Coconut Marzipan and Berries & Cream). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "AssortedVanilla")
                price = 15.00
            break
            case 7:
                title = "Sesame Crumb Coating"
                descriptionLabel.text = "Crunchy seasoned grainless 'breadcrumbs' with sesame. Use on anything from chicken, to fish, to veggies. Amazing baked or air fried! One pound container.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15 for a pack of 7."
                productImageView.image = UIImage(named: "CrumbsImg")
            break
            case 8:
                title = "FlavorfulFIX"
                descriptionLabel.text = "A healthy, clean, and vegan alternative to Duncan Hines or Betty Crocker mix. Just add a couple of wet ingredients, and bake as a loaf or muffins. Get the fix your sweet tooth craves the FlavorfulFIT way. Perfect for adults and kids!\nCertified Kosher Parve."
            break
            case 9:
                title = "Men's Two Week Jumpstart"
                productImageView.image = UIImage(named: "MensProgramImg")
            break
            case 10:
                title = "Women's Two Week Jumpstart"
                productImageView.image = UIImage(named: "WomensProgramImg")
            break
            
            default: title = ""
        }
        self.productTitle.text = title
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    
    
    @IBAction func orderButtonPressed(_ sender: Any) {
        if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" {
            showDropIn(clientTokenOrTokenizationKey: self.clientToken)
        } else {
            let alert = UIAlertController(title: "Form not properly filled out", message: "Please fill out form and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    @objc func back() {
        if Singleton.sharedInstance.requestedBarTag < 7 {
            performSegue(withIdentifier: "barOrderToBarSelect", sender: self)
        } else if Singleton.sharedInstance.requestedBarTag == 7 || Singleton.sharedInstance.requestedBarTag == 8 {
            performSegue(withIdentifier: "orderScreenToMixes", sender: self)
        } else if Singleton.sharedInstance.requestedBarTag == 9 || Singleton.sharedInstance.requestedBarTag == 10 {
            performSegue(withIdentifier: "orderScreenToPrograms", sender: self)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        back()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = -keyboardFrame.cgRectValue.height
        }
    }
    @objc func keyboardWillHide() {
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
    // SHOWS PAYMENT OPTIONS
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // IF ORDER FINISHED CHECKOUT, NONCE IS SENT TO SERVER USING METHOD BELOW
                self.postNonceToServer(paymentMethodNonce: (result.paymentMethod?.nonce)!)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        // SENDS POST INCLUDING NONCE AND PRICE TO SERVER AT /checkout
        let paymentURL = URL(string: "https://flavorfulfit.herokuapp.com/checkout")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce),price=\(price)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error == nil {
                var messageAddon = ""
                if Singleton.sharedInstance.requestedBarTag <= 8 {
                    messageAddon = "Your package will be ready for pickup on Sunday."
                } else {
                    messageAddon = "Check your email for your two-week program."
                }
                let alert = UIAlertController(title: "Success!", message: "Thanks for purchasing \(String(describing: self.productTitle.text)). \(messageAddon)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, packageOrdered: self.productTitle.text!)
            } else {
                let alert = UIAlertController(title: "Error!", message: "Something went wrong. Please ensure your credit card details are correct.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            print(response)
        }.resume()
    }
    func fetchClientToken() {
        let clientTokenURL = NSURL(string: "https://flavorfulfit.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            self.clientToken = String(data: data!, encoding: String.Encoding.utf8)
        }.resume()
    }
}

