import SwiftUI

struct HomeView: View {
    @State private var isPresenting = false

    var body: some View {
        VStack {
            Spacer()
            Text("HOME")
                .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
                .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
            Spacer()
        }
    
        Button(action: { isPresenting = true }) {
            Image(asset: AppAsset.Images.add)
                .resizable()
                .frame(width: 60, height: 60)
        }
        .offset(x: 144, y: -4)
        .sheet(isPresented: $isPresenting) {
            AddWordView()
        }
    }
}

#Preview {
    MainView()
}
