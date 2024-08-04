//
//  UserService.swift
//  App
//
//  Created by kwh on 7/4/24.
//
import Foundation
import JWTDecode

struct UserMDL {
    let id: Int
}

final class UserService {
    private init() {}
    static let shared = UserService()
    
    public var user: UserMDL? = nil
    
    func setUser(accessToken: String, refreshToken: String? = nil) async -> Bool {
        UserService.shared.setAccessToken(accessToken)
        UserService.shared.setRefreshToken(refreshToken)
        
        do {
            let jwt = try decode(jwt: accessToken)
            guard let userId = jwt.claim(name: "userId").integer else { return false }
            
            let result: Result<Components.Schemas.UserResponse, NetworkError> = await APIService.shared.fetch(.GET, "/users/\(userId)")
            
            switch result {
            case .success(let userInfo):
                user = UserMDL(id: userId)
                return true
            case .failure(let error):
                print("Get user data error: ", error)
            }
            
        } catch {
            print("User Info Setting Failed: ", error)
        }
        
        return false
    }
    
    func setAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultConstants.User.ACCESS_TOKEN)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultConstants.User.ACCESS_TOKEN)
    }
    
    func setRefreshToken(_ token: String?) {
        guard let token = token else { return }
        UserDefaults.standard.set(token, forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: UserDefaultConstants.User.ACCESS_TOKEN)
        UserDefaults.standard.removeObject(forKey: UserDefaultConstants.User.REFRESH_TOKEN)
    }
}
