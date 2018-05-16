//
//  Singleton.swift
//  FlavorfulFIT
//
//  Created by Ikey Benzaken on 2/18/18.
//  Copyright © 2018 Ikey Benzaken. All rights reserved.
//

import UIKit

class Singleton {
    class var sharedInstance: Singleton {
        struct Static {
            static let instance: Singleton = Singleton()
        }
        return Static.instance
    }
    var lastBarPurchaseTime = UserDefaults.standard.object(forKey: "LastPurchaseDate") {
        didSet {
            UserDefaults.standard.set(lastBarPurchaseTime, forKey: "LastPurchaseDate")
        }
    }
    var requestedBarTag: Int!
    var productsInCart: [Product] = []
}


