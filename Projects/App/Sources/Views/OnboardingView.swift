import SwiftUI

struct OnboardingView: View {
    @StateObject private var onBoarding = OnBoardingVM()
    
    var body: some View {
        NavigationStack(path: $onBoarding.path) {
            EmptyView().navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .HOME:
                    MainView().navigationBarHidden(true)
                case .SIGN_IN:
                    SignInView().navigationBarHidden(true)
                case .GUIDANCE:
                    GuidanceView().navigationBarHidden(true)
                }
            }
        }
        .environmentObject(onBoarding)
    }
    
}

#Preview {
    OnboardingView()
}
