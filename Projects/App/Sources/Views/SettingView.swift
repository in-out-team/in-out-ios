import SwiftUI

struct SettingView: View {
    var body: some View {
        Text("SETTING")
            .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
            .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
    }
}

#Preview {
    MainView()
}
