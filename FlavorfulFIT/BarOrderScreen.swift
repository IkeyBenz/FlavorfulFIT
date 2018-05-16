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
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var orderButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var orderbuttonHeight: NSLayoutConstraint!
    
    var clientToken: String!
    var braintreeClient: BTAPIClient!
    var price: Double!
    var shortDescription: String!
    let si = Singleton.sharedInstance
    
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
        
        productImageView.contentScaleFactor = CGFloat(UIViewContentMode.scaleAspectFit.rawValue)
        let tag = si.requestedBarTag!
        // Hide order button if they're looking at a bar and there's already a bar in the cart
        if tag < 7 {
            for product in si.productsInCart {
                if product.productTag < 7 {
                    self.orderButton.isHidden = true
                }
            }
        }
        
        var title = ""
        switch tag {
            case 1:
                title = "Coconut Marzipan"
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Decadent bar with coconut and almond flavor profile. Chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams of sugar. Grain free. Take one with water, keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "CoconutMarzipan")
                price = 15.00
            break
            case 2:
                title = "Berries & Cream"
                let desc = "Sweet vanilla base with a burst of cranberry in every bite. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "BerriesnCream")
                price = 15.00
            break
            case 3:
                title = "Chocolate Peanut Butter"
                let desc = "Delicious fudgey peanut butter bar. Crunchy peanuts and chocolate chips sprinkled throughout. A full nutritious meal at 200 calories with only 2 grams sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "ChocoPeanut")
                price = 15.00
            break
            case 4:
                title = "Chocolate Brownie"
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Rich chocolate brownie loaded with chocolate chips and deep cocoa flavor. A full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "ChocoBrownie")
                price = 15.00
            break
            case 5:
                title = "Assorted Chocolate"
                let bullets = "*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let desc = "Assorted box of chocolate-based FlavorfulFIT Meal Replacement Bars (Chocolate Peanut Butter and Chocolate Brownie). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains peanuts and tree nuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "AssortedChocolate")
                price = 15.00
            break
            case 6:
                title = "Assorted Vanilla";
                let desc = "Assorted box of vanilla-based FlavorfulFIT Meal Replacement Bars (Coconut Marzipan and Berries & Cream). Each one is a full nutritious meal at 200 calories, with only 2 grams of sugar. Grain free. Take one with water. Keep frozen.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $15.00 for a pack of 7."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Box of 7 bars."
                productImageView.image = UIImage(named: "AssortedVanilla")
                price = 15.00
            break
            case 7:
                title = "Sesame Crumb Coating"
                let desc = "Crunchy seasoned grainless 'breadcrumbs' with sesame. Use on anything from chicken, to fish, to veggies. Amazing baked or air fried! One pound container.\n\n*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $8.00 / 1lb container."
                let bullets = "*Contains tree nuts.\n*Processed on equipment that handles peanuts.\n- Certified Kosher Parve.\n- $8.00 / 1lb container."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "Crunchy seasoned breadcrumbs with sesame."
                price = 8.00
                productImageView.image = UIImage(named: "CrumbsImg")
            break
            case 8:
                title = "Flavorful FIX"
                descriptionLabel.text = "A healthy, clean, and vegan alternative to Duncan Hines or Betty Crocker mix. Just add a couple of wet ingredients, and bake as a loaf or muffins. Get the fix your sweet tooth craves the FlavorfulFIT way. Perfect for adults and kids!\nCertified Kosher Parve.\n- $7.00"
                shortDescription = "Healthy alternative to Duncan Hines or Betty Crocker mix"
                price = 7.00
                productImageView.image = UIImage(named: "CrumbsCover")
            break
            case 9:
                title = "Men's Two Week NoPrep"
                self.productTitle.font = UIFont(name: "TrebuchetMS", size: 32.0)
                let desc = "The FlavorfulFIT lifestyle is all about healthy, balanced meals to help you have a healthy, balanced life. But sometimes, preparing three meals a day can be tough.\n\nWhether you’re going on vacation, moving to a new house, or planning a wedding, busy days can get the best of us. Skipping meals and bingeing later can have a terrible effect on the body’s metabolism. But now, there is an FFApproved NoPrep program to help give you a break for two weeks.\n\nDesigned for people on the go, the 2 Week NoPrep will give you the break you need, while allowing you to lose weight in a consistent and healthy way, with no bounce back. This is a CLEAN, Whole Foods program with ingredients you easily recognize. FlavorfulFIT meal replacement bars, healthy snacks, and a homemade dinner will keep you energized throughout the day.\n\nMenus, recipes, and bars are all included! Plus, get admitted into a NoPrep chat, for extra motivation and assistance.\n\nThe 2 week NoPrep Program will be in between two weeks of your choice of the FlavorfulFIT Movement in a total of a one month enrollment. Week one of the month will be FFMovement, then 2 weeks of NoPrep, and another week of FFMovement will follow.\n\n- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                let bullets = "- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "All inclusive two week 'No-Prep' diet program for men"
                productImageView.image = UIImage(named: "MensProgramImg")
            break
            case 10:
                title = "Women's Two Week NoPrep"
                self.productTitle.font = UIFont(name: "TrebuchetMS", size: 32.0)
                let desc = "The FlavorfulFIT lifestyle is all about healthy, balanced meals to help you have a healthy, balanced life. But sometimes, preparing three meals a day can be tough.\n\nWhether you’re going on vacation, moving to a new house, or planning a wedding, busy days can get the best of us. Skipping meals and bingeing later can have a terrible effect on the body’s metabolism. But now, there is an FFApproved NoPrep program to help give you a break for two weeks.\n\nDesigned for people on the go, the 2 Week NoPrep will give you the break you need, while allowing you to lose weight in a consistent and healthy way, with no bounce back. This is a CLEAN, Whole Foods program with ingredients you easily recognize. FlavorfulFIT meal replacement bars, healthy snacks, and a homemade dinner will keep you energized throughout the day.\n\nMenus, recipes, and bars are all included! Plus, get admitted into a NoPrep chat, for extra motivation and assistance.\n\nThe 2 week NoPrep Program will be in between two weeks of your choice of the FlavorfulFIT Movement in a total of a one month enrollment. Week one of the month will be FFMovement, then 2 weeks of NoPrep, and another week of FFMovement will follow.\n\n- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                let bullets = "- New clients can choose to use NoPrep Program as week 2 and 3 of the FFMovement or later.\n- Existing members can choose to do NoPrep in between their current month, or any month they choose to fit in with their schedule.\n- Existing members can use the NoPrep Program as a boost to get past a plateau.\n\n***NoPrep Program is not to be done more than twice in a six month period.\n***Please visit Flavorful.com/about for more information on the FlavorfulFIT program. Teleconference introduction will be held Wednesday night at 8:30 PM Eastern. \n***Sharing any information from this program or any data from FlavorfulFIT is punishable in a court of law. FlavorfulFIT and all of its entities is copyrighted and is a registered trademark 2018.\n\nLife can get hectic. Easily take care of your health with the FlavorfulFIT NoPrep Program."
                descriptionLabel.attributedText = makeBulletsBolded(wholeStr: desc, bullets: bullets)
                shortDescription = "All inclusive two week 'No-Prep' diet program for women"
                productImageView.image = UIImage(named: "WomensProgramImg")
            break
            
            default: title = ""
        }
        self.productTitle.text = title
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(back))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(swipeGesture)
        
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
            self.shortDescription = "Includes verything you need to get started on your NoPrep diet plan."
            self.showNDA()
        }))
        alert.addAction(UIAlertAction(title: "Existing", style: UIAlertActionStyle.default, handler: {action in
            self.price = 130.00
            self.shortDescription = "Includes the next two weeks of your current program plus the NoPrep plan."
            self.showNDA()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func orderButtonPressed(_ sender: Any) {
//        let notFilledOut = UIAlertController(title: "Form not properly filled out", message: "Please fill out form and try again.", preferredStyle: UIAlertControllerStyle.alert)
//        notFilledOut.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        if orderButton.titleLabel!.text == "Add to Cart" {
//            let newProduct = Product(title: self.title, shortDesc: self.shortDescription, price: self.price)
//            let currentProducts = si.productsInCart as! [Product]
//            currentProducts.append(newProduct)
//
//            if si.requestedBarTag < 7 {
//                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" {
//                    if canBuyAtThisTime() {
//                        print("Showing Drop In")
//                        showDropIn(clientTokenOrTokenizationKey: self.clientToken)
//                    } else {
//                        let lastPurchaseTime = (si.lastBarPurchaseTime as! Date).description(with: Locale(identifier: "Day"))
//                        let day = lastPurchaseTime[...lastPurchaseTime.index(of: "y")!]
//                        let cantBuyAlert = UIAlertController(title: "Purchasing of bars is limited to once per weekly cycle.", message: "Please wait until \(day) to purchase again.", preferredStyle: UIAlertControllerStyle.alert)
//                        cantBuyAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(cantBuyAlert, animated: true, completion: nil)
//                    }
//                } else {
//                    self.present(notFilledOut, animated: true, completion: nil)
//                }
//            } else if si.requestedBarTag == 7 || si.requestedBarTag == 8 {
//                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" && quantityTF.text != "" {
//                    if si.requestedBarTag == 7 {
//                        self.price = 8.00 * Double(quantityTF.text!)!
//                    } else if si.requestedBarTag == 8 {
//                        self.price = 7.00 * Double(quantityTF.text!)!
//                    }
//                    showDropIn(clientTokenOrTokenizationKey: self.clientToken)
//                } else {
//                    self.present(notFilledOut, animated: true, completion: nil)
//                }
//            } else if si.requestedBarTag == 9 || si.requestedBarTag == 10 {
//                if nameTF.text != "" && emailTF.text != "" && phoneTF.text != "" && heightTF.text != "" && weightTF.text != "" {
//                    askIfUserIsNewOrOldCustomer()
//                } else {
//                    self.present(notFilledOut, animated: true, completion: nil)
//                }
//            }
//        } else if orderButton.titleLabel!.text == "I Agree to The Terms Listed Above" {
//            webView.isHidden = true
//            showDropIn(clientTokenOrTokenizationKey: self.clientToken)
//        }
        
        
        
       
        // If they're adding a program to their cart
        if si.requestedBarTag == 9 || si.requestedBarTag == 10 {
            if orderButton.titleLabel?.text! == "Add to Cart" {
                 askIfUserIsNewOrOldCustomer()
            } else if orderButton.titleLabel?.text! == "I Agree to The Terms Listed Above" {
                let newProduct = Product(title: self.productTitle.text!, shortDesc: self.shortDescription, price: self.price, image: self.productImageView.image!, quantityEditable: false, tag: si.requestedBarTag)
                si.productsInCart.append(newProduct)
            }
        // If they're adding a bar to their cart
        } else if si.requestedBarTag < 7 {
            if canBuyAtThisTime() {
                let newProduct = Product(title: self.productTitle.text!, shortDesc: self.shortDescription, price: self.price, image: self.productImageView.image!, quantityEditable: false, tag: si.requestedBarTag)
                si.productsInCart.append(newProduct)
                self.orderButton.isHidden = true
            } else {
                let lastPurchaseTime = (si.lastBarPurchaseTime as! Date).description(with: Locale(identifier: "Day"))
                let day = lastPurchaseTime[...lastPurchaseTime.index(of: "y")!]
                let cantBuyAlert = UIAlertController(title: "Purchasing of bars is limited to once per weekly cycle.", message: "Please wait until \(day) to purchase again.", preferredStyle: UIAlertControllerStyle.alert)
                cantBuyAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(cantBuyAlert, animated: true, completion: nil)
            }
        } else {
            let newProduct = Product(title: self.productTitle.text!, shortDesc: self.shortDescription, price: self.price, image: self.productImageView.image!, quantityEditable: true, tag: si.requestedBarTag)
            var incrimentedQuantity: Bool = false
            for product in si.productsInCart {
                if product.title == newProduct.title {
                    product.quantity += 1
                    incrimentedQuantity = true
                }
            }
            if !incrimentedQuantity {
                si.productsInCart.append(newProduct)
            }
            
        }
        for product in si.productsInCart {
            print("Title: \(product.title), Price: \(product.price), Quantity: \(product.quantity)")
        }
    }
    func canBuyAtThisTime() -> Bool {
        let lastPurchaseTime = si.lastBarPurchaseTime
        if lastPurchaseTime == nil {
            return true
        }
        return Date().timeIntervalSince(lastPurchaseTime as! Date) > 600000
    }
    
    @objc func back() {
        if si.requestedBarTag < 7 {
            performSegue(withIdentifier: "barOrderToBarSelect", sender: self)
        } else if si.requestedBarTag == 7 || si.requestedBarTag == 8 {
            performSegue(withIdentifier: "orderScreenToMixes", sender: self)
        } else if si.requestedBarTag == 9 || si.requestedBarTag == 10 {
            performSegue(withIdentifier: "orderScreenToPrograms", sender: self)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        back()
    }
    
    
}

