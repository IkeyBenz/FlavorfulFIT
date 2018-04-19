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
import WebKit

class BarOrderScreen: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var formContainer: UIStackView!
    @IBOutlet weak var formContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var orderButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var orderbuttonHeight: NSLayoutConstraint!
    
    var textfields: [UITextField] = []
    
    
    var clientToken: String!
    var braintreeClient: BTAPIClient!
    var price: Double = 0.01
    
    func showHeightAndWeight() {
        heightStackView.isHidden = false
        weightStackView.isHidden = false
        formContainerHeight.constant = 130
    }
    func showQuantityTF() {
        quantityStackView.isHidden = false
        formContainerHeight.constant = 115
    }
    func showNDA() {
        let path = Bundle.main.path(forResource: "NDA", ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        print(url)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.isHidden = false
        orderButton.setTitle("I Agree to The Terms Listed Above", for: .normal)
        orderButton.titleLabel?.numberOfLines = 3
        orderButton.titleLabel?.textAlignment = .center
        orderButtonWidth.constant = 120
        orderbuttonHeight.constant = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfields = [nameTF, emailTF, phoneTF, weightTF, heightTF, quantityTF]
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
            showHeightAndWeight()
        }
        if Singleton.sharedInstance.requestedBarTag == 7 || Singleton.sharedInstance.requestedBarTag == 8 {
            showQuantityTF()
        }
        fetchClientToken()
        productImageView.contentScaleFactor = CGFloat(UIViewContentMode.scaleAspectFit.rawValue)
        let tag = Singleton.sharedInstance.requestedBarTag!
        var title = ""
        switch tag {
            case 1:
                title = "Coconut Marzipan"
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Decadent bar with coconut and almond flavor profile. Chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams of sugar. Grain free. Take one with water, keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "CoconutMarzipan")
                price = 15.00
            break
            case 2:
                title = "Berries & Cream"
                let desc = "Sweet vanilla base with a burst of cranberry in every bite. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "BerriesnCream")
                price = 15.00
            break
            case 3:
                title = "Chocolate Peanut Butter"
                let desc = "Delicious fudgey peanut butter bar. Crunchy peanuts and chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "ChocoPeanut")
                price = 15.00
            break
            case 4:
                title = "Chocolate Brownie"
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Rich chocolate brownie loaded with chocolate chips and deep cocoa flavor. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "ChocoBrownie")
                price = 15.00
            break
            case 5:
                title = "Assorted Chocolate"
                let bullets = "*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Assorted box of chocolate-based FlavorfulFIT Meal Replacement Bars (Chocolate Peanut Butter and Chocolate Brownie). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "AssortedChocolate")
                price = 15.00
            break
            case 6:
                title = "Assorted Vanilla";
                let desc = "Assorted box of vanilla-based FlavorfulFIT Meal Replacement Bars (Coconut Marzipan and Berries & Cream). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "AssortedVanilla")
                price = 15.00
            break
            case 7:
                title = "Sesame Crumb Coating"
                let desc = "Crunchy seasoned grainless 'breadcrumbs' with sesame. Use on anything from chicken, to fish, to veggies. Amazing baked or air fried! One pound container.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $8.00 / 1lb container."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $8.00 / 1lb container."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                price = 8.00
                productImageView.image = UIImage(named: "CrumbsImg")
            break
            case 8:
                title = "Flavorful FIX"
                descriptionLabel.text = "A healthy, clean, and vegan alternative to Duncan Hines or Betty Crocker mix. Just add a couple of wet ingredients, and bake as a loaf or muffins. Get the fix your sweet tooth craves the FlavorfulFIT way. Perfect for adults and kids!\nCertified Kosher Parve.\n- $7.00"
                price = 7.00
                productImageView.image = UIImage(named: "CrumbsCover")
            break
            case 9:
                title = "Men's Two Week NoPrep"
                self.productTitle.font = UIFont(name: "TrebuchetMS", size: 32.0)
                let desc = "The FlavorfulFIT lifestyle is all about healthy, balanced meals to help you have a healthy, balanced life. But sometimes, preparing three meals a day can be tough.\n\nWhether you’re going on vacation, moving to a new house, or planning a wedding, busy days can get the best of us. Skipping meals and bingeing later can have a terrible effect on the body’s metabolism. But now, there is an FFApproved NoPrep program to help give you a break for two weeks.\n\nDesigned for people on the go, the 2 Week NoPrep will give you the break you need, while allowing you to lose weight in a consistent and healthy way, with no bounce back. This is a CLEAN, Whole Foods program with ingredients you easily recognize. FlavorfulFIT meal replacement bars, healthy snacks, and a homemade dinner will keep you energized throughout the day.\n\nMenus, recipes, and bars are all included! Plus, get admitted into a NoPrep chat, for extra motivation and assistance.\n\nThe 2 week NoPrep Program will be in between two weeks of your choice of the FlavorfulFIT Movement in a total of a one month enrollment. Week one of the month will be FFMovement, then 2 weeks of NoPrep, and another week of FFMovement will follow.\n\n- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                let bullets = "- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "MensProgramImg")
            break
            case 10:
                title = "Women's Two Week NoPrep"
                self.productTitle.font = UIFont(name: "TrebuchetMS", size: 32.0)
                let desc = "The FlavorfulFIT lifestyle is all about healthy, balanced meals to help you have a healthy, balanced life. But sometimes, preparing three meals a day can be tough.\n\nWhether you’re going on vacation, moving to a new house, or planning a wedding, busy days can get the best of us. Skipping meals and bingeing later can have a terrible effect on the body’s metabolism. But now, there is an FFApproved NoPrep program to help give you a break for two weeks.\n\nDesigned for people on the go, the 2 Week NoPrep will give you the break you need, while allowing you to lose weight in a consistent and healthy way, with no bounce back. This is a CLEAN, Whole Foods program with ingredients you easily recognize. FlavorfulFIT meal replacement bars, healthy snacks, and a homemade dinner will keep you energized throughout the day.\n\nMenus, recipes, and bars are all included! Plus, get admitted into a NoPrep chat, for extra motivation and assistance.\n\nThe 2 week NoPrep Program will be in between two weeks of your choice of the FlavorfulFIT Movement in a total of a one month enrollment. Week one of the month will be FFMovement, then 2 weeks of NoPrep, and another week of FFMovement will follow.\n\n- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                let bullets = "- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                productImageView.image = UIImage(named: "WomensProgramImg")
            break
            
            default: title = ""
        }
        self.productTitle.text = title
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textfield in self.textfields {
            if textfield.isFirstResponder {
                textfield.resignFirstResponder()
            }
        }
    }
    func makeBulletsBolded(wholeStr: String, bullets: String) -> NSMutableAttributedString {
        let regularFont = UIFont(name: "TrebuchetMS", size: 18.0)
        let boldFont = UIFont(name: "TrebuchetMS-Bold", size: 18.0)
        let boldStrRange = (wholeStr as NSString).range(of: bullets)
        let attributedString = NSMutableAttributedString(string: wholeStr, attributes: [NSAttributedStringKey.font : regularFont!])
        attributedString.setAttributes([NSAttributedStringKey.font : boldFont!], range: boldStrRange)
        return attributedString
    }
    
    func askIfUserIsNewOrOldCustomer() {
        let alert = UIAlertController(title: "Are you a new or already existing customer?", message: "New customers will receive week 1 and week 2 of the FlavorfulFIT Movement including detox, plus the NoPrep Plan. Existing customers will receive their next two weeks plus NoPrep Plan.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "New", style: UIAlertActionStyle.default, handler: {action in
            self.price = 170.00
            self.showNDA()
        }))
        alert.addAction(UIAlertAction(title: "Existing", style: UIAlertActionStyle.default, handler: {action in
            self.price = 130.00
            self.showNDA()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func orderButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Form not properly filled out", message: "Please fill out form and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        if orderButton.titleLabel!.text == "Order" {
            if Singleton.sharedInstance.requestedBarTag < 7 {
                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" {
                    if canBuyAtThisTime() {
                        showDropIn(clientTokenOrTokenizationKey: self.clientToken)
                    } else {
                        let lastPurchaseTime = (Singleton.sharedInstance.lastBarPurchaseTime as! Date).description(with: Locale(identifier: "Day"))
                        let day = lastPurchaseTime[...lastPurchaseTime.index(of: "y")!]
                        let cantBuyAlert = UIAlertController(title: "Purchasing of bars is limited to once per weekly cycle.", message: "Please wait until \(day) to purchase again.", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(cantBuyAlert, animated: true, completion: nil)
                    }
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            } else if Singleton.sharedInstance.requestedBarTag == 7 || Singleton.sharedInstance.requestedBarTag == 8 {
                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" && quantityTF.text != "" {
                    if Singleton.sharedInstance.requestedBarTag == 7 {
                        self.price = 8.00 * Double(quantityTF.text!)!
                    } else if Singleton.sharedInstance.requestedBarTag == 8 {
                        self.price = 7.00 * Double(quantityTF.text!)!
                    }
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            } else if Singleton.sharedInstance.requestedBarTag == 9 || Singleton.sharedInstance.requestedBarTag == 10 {
                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" && heightTF.text != "" && weightTF.text != "" {
                    askIfUserIsNewOrOldCustomer()
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if orderButton.titleLabel!.text == "I Agree to The Terms Listed Above" {
            webView.isHidden = true
            showDropIn(clientTokenOrTokenizationKey: self.clientToken)
        }
    }
    func canBuyAtThisTime() -> Bool {
        let lastPurchaseTime = Singleton.sharedInstance.lastBarPurchaseTime
        if lastPurchaseTime == nil {
            return true
        }
<<<<<<< Updated upstream
        
        let itsBeenMoreThanAweek = Date().timeIntervalSince(lastPurchaseTime as! Date) > 604800
        let todayDesc = Date().description(with: Locale(identifier: "Day"))
        let prevDesc = (lastPurchaseTime as! Date).description(with: Locale(identifier: "Day"))
        let sameDayOfWeek = todayDesc[...todayDesc.index(of: "y")!] == prevDesc[...prevDesc.index(of: "y")!]
        let itsBeenMoreThanAday = Date().timeIntervalSince(lastPurchaseTime as! Date) > 86400

        return itsBeenMoreThanAweek || (sameDayOfWeek && itsBeenMoreThanAday)
=======
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let now = calendar!.components([.day, .month, .weekOfMonth, .year], from: Date())
        let before = calendar!.components([.day, .month, .weekOfMonth, .year], from: lastPurchaseTime as! Date)
        // If today is Sunday, prevent them from buying bars altogether
        if now.weekday == 1 {
            return false
        }
        // If todays week of the month (1,2,3,4) is different from last purchases week of the month, let them buy. Purchasing on the first week of two different months would result in prevention of buying so I also check if the months are the same. Same goes for the same month of two different years, so I included that they're allowed to buy if the years are different
        return now.weekOfMonth != before.weekOfMonth || now.month != before.month || now.year != before.year
>>>>>>> Stashed changes
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
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        }
        if textField == emailTF {
            phoneTF.becomeFirstResponder()
        }
        if textField == phoneTF {
            if Singleton.sharedInstance.requestedBarTag < 7 {
                phoneTF.resignFirstResponder()
            }
            if Singleton.sharedInstance.requestedBarTag == 7 || Singleton.sharedInstance.requestedBarTag == 8 {
                quantityTF.becomeFirstResponder()
            }
            if Singleton.sharedInstance.requestedBarTag == 9 || Singleton.sharedInstance.requestedBarTag == 10 {
                heightTF.becomeFirstResponder()
            }
        }
        if textField == heightTF {
            weightTF.becomeFirstResponder()
        }
        if textField == weightTF {
            weightTF.resignFirstResponder()
        }
        if textField == quantityTF {
            quantityTF.resignFirstResponder()
        }
        return true
    }
}

extension BarOrderScreen {
    func submitInfoToGoogleForm(name: String, email: String, phone: String, height: String, weight: String, packageOrdered: String, quantity: String) {
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSduPIk62Xwzf6gZP_tI4I1L1_u3cdyZw4Se0K_mQgDjXK09ow/formResponse")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "xml")
        request.httpMethod = "POST"
        let postString = "entry.551467928=\(name)&entry.286274381=\(email)&entry.854835347=\(phone)&entry.39836842=\(packageOrdered)&entry.1549493791=\(height)&entry.2068669238=\(weight)&entry.2012819739=\(quantity)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
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
                self.orderButton.setTitle("Order", for: .normal)
                self.orderButtonWidth.constant = 60
                self.orderbuttonHeight.constant = 35
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
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&&price=\(price)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error == nil {
                var messageAddon = ""
                if Singleton.sharedInstance.requestedBarTag <= 8 {
                    messageAddon = "Your package will be ready for pickup on Sunday."
                } else {
                    messageAddon = "Your two-week program will be emailed to you within two business days."
                }
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success!", message: "Thanks for purchasing \(String(describing: self.productTitle.text!)). \(messageAddon)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    if Singleton.sharedInstance.requestedBarTag < 7 {
                        Singleton.sharedInstance.lastBarPurchaseTime = Date()
                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: "--", weight: "--", packageOrdered: self.productTitle.text!, quantity: "--")
                    } else if Singleton.sharedInstance.requestedBarTag == 7 || Singleton.sharedInstance.requestedBarTag == 8 {
                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: "--", weight: "--", packageOrdered: self.productTitle.text!, quantity: self.quantityTF.text!)
                    } else if Singleton.sharedInstance.requestedBarTag == 9 || Singleton.sharedInstance.requestedBarTag == 10 {
                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: self.heightTF.text!, weight: self.weightTF.text!, packageOrdered: self.productTitle.text!, quantity: "--")
                    }
                }
                
            } else {
                let errorAlert = UIAlertController(title: "Error!", message: "Something went wrong. Please ensure your credit card details are correct.", preferredStyle: UIAlertControllerStyle.alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
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
