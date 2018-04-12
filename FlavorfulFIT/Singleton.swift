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
}

extension UserDefaults {
    
    static let defaults = UserDefaults.standard
    
    static var lastAccessDate: Date? {
        get {
            return defaults.object(forKey: "lastAccessDate") as? Date
        }
        set {
            guard let newValue = newValue else { return }
            guard let lastAccessDate = lastAccessDate else {
                defaults.set(newValue, forKey: "lastAccessDate")
                return
            }
            if !Calendar.current.isDateInToday(lastAccessDate) {
                UserDefaults.reset()
            }
            defaults.set(newValue, forKey: "lastAccessDate")
        }
    }
    
    static func reset() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
    }
}
