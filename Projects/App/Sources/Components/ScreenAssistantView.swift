import SwiftUI

enum ScreenAssistantButtonType {
    case scrollUp
    case scrollDown
    case clearInput
    case focusInput
    case hideKeypad
    case dismiss
    
    var image: AppImages {
        switch self {
        case .scrollUp:
            return AppAsset.Images.scrollUp
        case .scrollDown:
            return AppAsset.Images.scrollDown
        case .clearInput:
            return AppAsset.Images.eraser
        case .focusInput:
            return AppAsset.Images.focusInput
        case .hideKeypad:
            return AppAsset.Images.hideKeypad
        case .dismiss:
            return AppAsset.Images.dismiss
        }
    }
}

struct ScreenAssistantButton {
    let type: ScreenAssistantButtonType
    let action: () -> Void
}

struct ScreenAssistantView: View {
    var leftButtons: [ScreenAssistantButton] = []
    var centerButtons: [ScreenAssistantButton] = []
    var rightButtons: [ScreenAssistantButton] = []
    
    var body: some View {
        HStack {
            
            if centerButtons.isEmpty {
                
                HStack(spacing: 0) {
                    ForEach(leftButtons, id: \.type) { button in
                        Button(action: button.action) {
                            Image(asset: button.type.image)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                
                HStack(spacing: 0) {
                    ForEach(rightButtons, id: \.type) { button in
                        Button(action: button.action) {
                            Image(asset: button.type.image)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 8)
                
            } else {
                
                HStack(spacing: 0) {
                    ForEach(centerButtons, id: \.type) { button in
                        Button(action: button.action) {
                            Image(asset: button.type.image)
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(
            AppAsset.Colors.tertiaryPurpleBG.swiftUIColor
                .cornerRadius(20)
                .edgesIgnoringSafeArea(.bottom)
                .opacity(0.2)
            // TODO: blur
        )
    }
}
