import SwiftUI



struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("HOME")
                .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
                .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
            Spacer()
        }
    
        Button(action: {}) {
            Image(asset: AppAsset.Images.add)
                .resizable()
                .frame(width: 60, height: 60)
        }.offset(x: 144, y: -4)
    }
}

#Preview {
    MainView()
}
