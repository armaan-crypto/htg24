//
//  Constants.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import Foundation
import SwiftUI

struct K {
    struct colors {
        static let blue = Color("blue")
        static let green = Color("green")
        static let grayGreen = Color("grayGreen")
    }
    
    struct saved {
        struct ids {
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let email = "email"
            static let industry = "industry"
            static let risk = "risk"
        }
        static var firstName: String {
            return UserDefaults.standard.string(forKey: ids.firstName) ?? "NONE"
        }
        static var lastName: String {
            return UserDefaults.standard.string(forKey: ids.lastName) ?? "NONE"
        }
        static var email: String {
            return UserDefaults.standard.string(forKey: ids.email) ?? "NONE"
        }
        static var industry: String {
            return UserDefaults.standard.string(forKey: ids.industry) ?? "NONE"
        }
        static var risk: String {
            return UserDefaults.standard.string(forKey: ids.risk) ?? "NONE"
        }
        static func save(_ value: Any?, to id: String) {
            UserDefaults.standard.setValue(value, forKey: id)
        }
//        UserDefaults.statndard.setValue("Hello", forKey: "username")
//        UserDefaults.standard.value(forKey: "username") != nil
        
    }
}
