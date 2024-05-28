//
//  Config.swift
//  App
//
//  Created by kwh on 5/27/24.
//

import Foundation

public enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist not found")
        }
        
        return dict
    }()
    
    static var apiUrl: URL = {
        guard let baseUrl = Config.infoDictionary[Keys.apiUrl.rawValue] as? String else {
            fatalError("API URL not set in plist")
        }
        
        guard let url = URL(string: baseUrl) else {
            fatalError("API URL is invalid")
        }
        
        return url
    }()
    
    static var apiDocURL: URL = {
        guard let url = Config.infoDictionary[Keys.apiDocUrl.rawValue] as? String else {
            fatalError("API DOC URL not set in plist")
        }
        
        guard let apiDocUrl = URL(string: url) else {
            fatalError("API DOC URL is invalid")
        }
        
        return apiDocUrl
    }()
    
    static let appEnv: String = {
        guard let appEnv = Config.infoDictionary[Keys.appEnv.rawValue] as? String else {
            fatalError("APP ENV not set in plist")
        }
        
        return appEnv
    }()
    
    static let buildEnv: String = {
        #if DEBUG
            return "DEBUG"
        #elseif ADHOC
            return "ADHOC"
        #else
            return "RELEASE"
        #endif
    }()
    
    private enum Keys: String {
        case appEnv = "APP_ENV"
        case apiUrl = "API_URL"
        case apiDocUrl = "API_DOC_URL"
    }
}
