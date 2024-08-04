//
//  UserDefaultConstant.swift
//  App
//
//  Created by kwh on 7/4/24.
//

import Foundation

struct UserDefaultConstants {
    private init() {}

    static let allKeys = [
        // MARK: User
        User.ACCESS_TOKEN,
        User.REFRESH_TOKEN,
        User.HAS_SEEN_GUIDE
        
        // ...Others
    ]
    
    struct User {
        static let ACCESS_TOKEN = "ACCESS_TOKEN"
        static let REFRESH_TOKEN = "REFRESH_TOKEN"
        static let HAS_SEEN_GUIDE = "HAS_SEEN_GUIDE"
    }
    
    // ...Others
}
