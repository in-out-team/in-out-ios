import SwiftUI

struct TalkToAiView: View {
    var body: some View {
        Text("TALK TO AI")
            .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
            .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
    }
}

#Preview {
    MainView()
}
