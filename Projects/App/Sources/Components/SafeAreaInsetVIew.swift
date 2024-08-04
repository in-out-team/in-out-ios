import SwiftUI

struct SafeAreaInsetView<Content: View>: View {
    var alignment: Alignment
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                content()
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .frame(maxWidth: .infinity, alignment: alignment)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
