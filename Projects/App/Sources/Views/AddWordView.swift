import SwiftUI

struct AddWordView: View {
    @StateObject private var addWordVM = AddWordVM()
    @FocusState private var focusField: AddWordVM.Field?
    
    var body: some View {
        VStack(alignment: .center) {
            
            TextField("", text: $addWordVM.word)
                .padding(.top, 32)
                .padding(.bottom, 16)
                .font(AppFontFamily.Pretendard.extraBold.swiftUIFont(size: 26))
                .foregroundColor(AppAsset.Colors.primaryText
                    .swiftUIColor)
                .tint(AppAsset.Colors.primaryText
                    .swiftUIColor)
                .multilineTextAlignment(.center)
                .background(.clear)
                .focused($focusField, equals: .wordField)
                .onAppear { focusField = .wordField }
            
            Divider().padding(.horizontal, 16)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(addWordVM.categories, id: \.title) { category in
                        
                        TagView(
                            title: category.title.rawValue,
                            titleColor: category.titleColor,
                            backgroundColor: category.backgroundColor
                        )
                        
                    }
                }
                .padding(.vertical, 8)
                .padding(.leading, 16)
            }
            
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    ForEach(0..<50) { index in
                        
                        VStack {
                            Text("Item \(index)")
                                .foregroundColor(.black)
                            
                        }
                        .frame(maxWidth: .infinity, minHeight: 86)
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(
                            color: .black.opacity(0.25),
                            radius: 4, x: 0, y: 0
                        )
                    }
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity)
            
        }
        
        .background(.white)
        
    }
}

#Preview {
    MainView()
}
