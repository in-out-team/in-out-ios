import SwiftUI
import Foundation
import GoogleSignIn

enum Screen: String {
    case HOME
    case SIGN_IN
    case GUIDANCE
}

enum PROVIDER {
    case GOOGLE
    case KAKAO
    case APPLE
}

class OnBoardingVM: ObservableObject {
    @Published var path: [Screen] = [] {
        didSet {
#if DEBUG
            print("path: ", path)
#endif
        }
    }
    
    @Published var hasSeenGuidance = false {
        didSet {
            
            DispatchQueue.main.async {
                if self.hasSeenGuidance {
                    self.path.append(.SIGN_IN)
                } else {
                    self.path.append(.GUIDANCE)
                }
            }
            
        }
    }
    
    @Published var isAuthenticated = false {
        didSet {
            guard hasSeenGuidance else { return }
            
            DispatchQueue.main.async {
                if self.isAuthenticated {
                    self.path.append(.HOME)
                } else {
                    self.path.append(.SIGN_IN)
                }
            }
            
        }
    }
    
    init() {
        checkHasSeenGuidance()
        checkAccessToken()
    }
    
    private func checkHasSeenGuidance() {
        hasSeenGuidance = UserDefaults.standard.bool(forKey: UserDefaultConstants.User.HAS_SEEN_GUIDE)
    }
    
    private func checkAccessToken() {
        guard let accessToken = UserService.shared.getAccessToken() else {
            isAuthenticated = false
            return
        }
        
        isAuthenticated = !accessToken.isEmpty
    }
    
    func onCompleteGuidance() {
        hasSeenGuidance = true
        UserDefaults.standard.set(true, forKey: UserDefaultConstants.User.HAS_SEEN_GUIDE)
    }
    
    func getGoogleAuth() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [self] result, error in
            
            guard error == nil else { return }
            guard let tokenString = result?.user.idToken?.tokenString else { return }
            
            Task {
                await getUserAuthToken(provider: .GOOGLE, providerId: tokenString)
            }
            
        }
    }
    
    private func getUserAuthToken(
        provider: PROVIDER,
        providerId: String
    ) async {
        let result: Result<Components.Schemas.TokenResponse, NetworkError> = await APIService.shared.fetch(
            .POST,
            "/auth/login/google",
            nil,
            Components.Schemas.GoogleLoginRequest(idToken: providerId)
        )
        
        switch result {
        case .success(let token):
            
            #if DEBUG
            print("accessToken: ", token.accessToken)
            // print("refreshToken: ", token.refreshToken)
            #endif
            
            // 유저 세팅
            let result = await UserService.shared.setUser(accessToken: token.accessToken)
            if result {
                
                DispatchQueue.main.async { [weak self] in
                    self?.isAuthenticated = true
                }
                
            } else {
                // 유저 세팅 실패시
                
            }
            
            
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                break
            default:
                // Other Error(Network, badUrl ...)
                break
            }
        }
    }
    
}
