import SwiftUI

struct TagView: View {
    var title: String
    var titleColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .font(AppFontFamily.Pretendard.extraBold.swiftUIFont(size: 16))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundColor(titleColor)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

#Preview {
    MainView()
}
