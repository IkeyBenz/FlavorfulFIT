//
//  CartScreen.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 4/30/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class CartScreen: UIViewController {
    
//    @IBOutlet weak var nameTF: UITextField!
//    @IBOutlet weak var emailTF: UITextField!
//    @IBOutlet weak var phoneTF: UITextField!
//    @IBOutlet weak var heightTF: UITextField!
//    @IBOutlet weak var weightTF: UITextField!
//    var textFields: [UITextField] = []
//
//    @IBOutlet weak var heightStackView: UIStackView!
//    @IBOutlet weak var weightStackView: UIStackView!
//    @IBOutlet weak var formContainer: UIStackView!
//    @IBOutlet weak var formContainerHeight: NSLayoutConstraint!
//
//    @IBOutlet weak var cartStackView: UIStackView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    var textFields: [UITextField] = []
    
    @IBOutlet weak var cartStackView: UIStackView!
    
    var total: Double = 0.0
    @IBOutlet weak var totalLabel: UILabel!
    
    let si = Singleton.sharedInstance
    
    override func viewDidLoad() {
        self.textFields = [self.nameTF, self.emailTF, self.phoneTF, self.heightTF, self.weightTF]
        let products = Singleton.sharedInstance.productsInCart
        var count = 0
        for product in products {
            let cartItemView = CartItem(frame: CGRect(x: 0, y: count * 100, width: 300, height: 100), product: product)
            self.cartStackView.addSubview(cartItemView)
            NSLayoutConstraint(item: cartItemView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: cartStackView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0).isActive = true
            cartItemView.addContraints()
            count += 1
            self.total += product.price * Double(product.quantity)
        }
        self.totalLabel.text = "$" + String(self.total) + "0"
        
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
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textfield in self.textFields {
            if textfield.isFirstResponder {
                textfield.resignFirstResponder()
            }
        }
        for touch in touches {
            print(touch.location(in: self.cartStackView.subviews[0]))
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            self.view.frame.origin.y = -keyboardFrame.cgRectValue.height
        }
    }
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    
    @IBAction func checkout(_ sender: Any) {
        let fillOutFormAlert = UIAlertController(title: "Form not properly filled out.", message: "Please make sure all fields are properly filled out before checking out.", preferredStyle: UIAlertControllerStyle.alert)
        fillOutFormAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        var formIsFilledOut = true
        for textField in self.textFields {
            if textField.text == "" {
                formIsFilledOut = false
            }
        }
        if formIsFilledOut {
            
        } else {
            self.present(fillOutFormAlert, animated: true, completion: nil)
        }
    }
    
}
class CartItem: UIView {
    var product: Product
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
    let titleLabel = UILabel(frame: CGRect(x: 100, y: 10, width: 200, height: 25))
    let descriptionLabel = UILabel(frame: CGRect(x: 100, y: 45, width: 200, height: 45))
    let quantityLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 80, height: 15))
    let quantityToggleView = UIStackView(frame: CGRect(x: 310, y: 45, width: 80, height: 45))
    let incrimentQuantityButton = UIButton(type: UIButtonType.roundedRect)
    let decrimentQuantityButton = UIButton(type: UIButtonType.roundedRect)
    
    @objc func incrimentQuantity() {
        product.quantity += 1
        print("yes")
        quantityLabel.text = String(product.quantity)
    }
    @objc func decrimentQuantity() {
        print("no")
        product.quantity -= 1
        quantityLabel.text = String(product.quantity)
    }
    
    init(frame: CGRect, product: Product) {
        self.product = product
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        quantityLabel.text = String(product.quantity)
        
        self.imageView.image = product.image
        self.addSubview(imageView)
        
        titleLabel.text = product.title
        self.addSubview(titleLabel)
        
        descriptionLabel.text = product.desc
        descriptionLabel.numberOfLines = 0
        self.addSubview(descriptionLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: 310, y: 10, width: 80, height: 25))
        priceLabel.text = "$" + String(product.price) + "0"
        self.addSubview(priceLabel)
        
        if product.canChangeQuantity {
            incrimentQuantityButton.isUserInteractionEnabled = true
            incrimentQuantityButton.addTarget(quantityToggleView, action: #selector(incrimentQuantity), for: UIControlEvents.touchUpInside)
            print(incrimentQuantityButton.frame.origin)
            incrimentQuantityButton.backgroundColor = UIColor.black
            incrimentQuantityButton.setTitle("+", for: UIControlState.normal)
            decrimentQuantityButton.addTarget(quantityToggleView, action: #selector(decrimentQuantity), for: UIControlEvents.touchUpInside)
            decrimentQuantityButton.setTitle("-", for: UIControlState.normal)
            decrimentQuantityButton.backgroundColor = UIColor.black
            quantityToggleView.addSubview(incrimentQuantityButton)
            quantityToggleView.addSubview(quantityLabel)
            quantityToggleView.addSubview(decrimentQuantityButton)
            quantityToggleView.bringSubview(toFront: incrimentQuantityButton)
            quantityToggleView.bringSubview(toFront: decrimentQuantityButton)
            
            self.addSubview(quantityToggleView)
            self.bringSubview(toFront: quantityToggleView)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addContraints() {
        // Image contraints
        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 80).isActive = true
        
        // Constraits for titleLabel
        NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
        
        // Constraints for descriptionLabel
        NSLayoutConstraint(item: descriptionLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: descriptionLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: titleLabel, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10).isActive = true
        
        if product.canChangeQuantity {
            NSLayoutConstraint(item: quantityToggleView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 80).isActive = true
            NSLayoutConstraint(item: quantityToggleView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 80).isActive = true
            NSLayoutConstraint(item: quantityToggleView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
            NSLayoutConstraint(item: quantityToggleView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 10).isActive = true
            NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: quantityToggleView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
            NSLayoutConstraint(item: descriptionLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: quantityToggleView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
            
            // Constraints for buttons
            NSLayoutConstraint(item: incrimentQuantityButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 80).isActive = true
            NSLayoutConstraint(item: incrimentQuantityButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 15).isActive = true
            
            
        } else {
            NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
            NSLayoutConstraint(item: descriptionLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 10).isActive = true
        }
    }
}
class Product {
    var title: String
    var desc: String
    var price: Double
    var image: UIImage
    var quantity: Int = 1
    var canChangeQuantity: Bool
    var productTag: Int
    
    init(title: String, shortDesc: String, price: Double, image: UIImage, quantityEditable: Bool, tag: Int) {
        self.title = title
        self.desc = shortDesc
        self.price = price
        self.image = image
        self.canChangeQuantity = quantityEditable
        self.productTag = tag
    }
}

extension CartScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            emailTF.becomeFirstResponder()
        }
        if textField == emailTF {
            phoneTF.becomeFirstResponder()
        }
        if textField == phoneTF {
            heightTF.becomeFirstResponder()
        }
        if textField == heightTF {
            weightTF.becomeFirstResponder()
        }
        if textField == weightTF {
            weightTF.resignFirstResponder()
        }
        return true
    }
}

//extension CartScreen {
//    func submitInfoToGoogleForm(name: String, email: String, phone: String, height: String, weight: String, packageOrdered: String, quantity: String) {
//        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSduPIk62Xwzf6gZP_tI4I1L1_u3cdyZw4Se0K_mQgDjXK09ow/formResponse")!
//        var request = URLRequest(url: url)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "xml")
//        request.httpMethod = "POST"
//        let postString = "entry.551467928=\(name)&entry.286274381=\(email)&entry.854835347=\(phone)&entry.39836842=\(packageOrdered)&entry.1549493791=\(height)&entry.2068669238=\(weight)&entry.2012819739=\(quantity)"
//        request.httpBody = postString.data(using: .utf8)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print("error=\(String(describing: error))")
//                return
//            }
//
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(String(describing: response))")
//            }
//
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
//        }
//        task.resume()
//    }
//}
//
//extension CartScreen {
//    // SHOWS PAYMENT OPTIONS
//    func showDropIn(clientTokenOrTokenizationKey: String) {
//        let request =  BTDropInRequest()
//        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
//            if (error != nil) {
//                print("ERROR")
//            } else if (result?.isCancelled == true) {
//                print("CANCELLED")
//                self.orderButton.setTitle("Order", for: .normal)
//                self.orderButtonWidth.constant = 60
//                self.orderbuttonHeight.constant = 35
//            } else if let result = result {
//                // IF ORDER FINISHED CHECKOUT, NONCE IS SENT TO SERVER USING METHOD BELOW
//                self.postNonceToServer(paymentMethodNonce: (result.paymentMethod?.nonce)!)
//            }
//            controller.dismiss(animated: true, completion: nil)
//        }
//        self.present(dropIn!, animated: true, completion: nil)
//    }
//
//    func postNonceToServer(paymentMethodNonce: String) {
//        // SENDS POST INCLUDING NONCE AND PRICE TO SERVER AT /checkout
//        let paymentURL = URL(string: "https://flavorfulfit.herokuapp.com/checkout")!
//        var request = URLRequest(url: paymentURL)
//        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&&price=\(price)".data(using: String.Encoding.utf8)
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
//            if error == nil {
//                var messageAddon = ""
//                if self.si.requestedBarTag <= 8 {
//                    messageAddon = "Your package will be ready for pickup on Sunday."
//                } else {
//                    messageAddon = "Your two-week program will be emailed to you within two business days."
//                }
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "Success!", message: "Thanks for purchasing \(String(describing: self.productTitle.text!)). \(messageAddon)", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    if self.si.requestedBarTag < 7 {
//                        self.si.lastBarPurchaseTime = Date()
//                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: "", weight: "", packageOrdered: self.productTitle.text!, quantity: "")
//                    } else if self.si.requestedBarTag == 7 || self.si.requestedBarTag == 8 {
//                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: "", weight: "", packageOrdered: self.productTitle.text!, quantity: self.quantityTF.text!)
//                    } else if self.si.requestedBarTag == 9 || self.si.requestedBarTag == 10 {
//                        self.submitInfoToGoogleForm(name: self.nameTF.text!, email: self.emailTF.text!, phone: self.phoneTF.text!, height: self.heightTF.text!, weight: self.weightTF.text!, packageOrdered: self.productTitle.text!, quantity: "")
//                    }
//                }
//
//            } else {
//                let errorAlert = UIAlertController(title: "Error!", message: "Something went wrong. Please ensure your credit card details are correct.", preferredStyle: UIAlertControllerStyle.alert)
//                errorAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(errorAlert, animated: true, completion: nil)
//            }
//            }.resume()
//    }
//    func fetchClientToken() {
//        let clientTokenURL = NSURL(string: "https://flavorfulfit.herokuapp.com/client_token")!
//        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
//        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
//
//        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
//            self.clientToken = String(data: data!, encoding: String.Encoding.utf8)
//            }.resume()
//    }
//}


