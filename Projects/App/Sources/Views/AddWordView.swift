import SwiftUI

struct AddWordView: View {
    @StateObject private var addWordVM = AddWordVM()
    @FocusState private var focusField: AddWordVM.Field?
    @StateObject private var keyboardObserver = KeyboardObserver()
    @Binding var isPresenting: Bool
    
    @State private var isDidShowKeyboard: Bool = false
    
    func leftToolbarButtons() -> [ScreenAssistantButton] {
        return [
            ScreenAssistantButton(type: .clearInput, action: {
                addWordVM.searchText = ""
            }),
            ScreenAssistantButton(type: .hideKeypad, action: {
                UIApplication.shared.endEditing(true)
            })
        ]
    }
    
    func centerToolbarButtons() -> [ScreenAssistantButton] {
        return [
            ScreenAssistantButton(type: .dismiss, action: {
                isPresenting = false
            }),
            ScreenAssistantButton(type: .focusInput, action: {
                focusField = .wordField
            })
        ]
    }
    
    func rightToolbarButtons(proxy: ScrollViewProxy) -> [ScreenAssistantButton] {
        return [
            ScreenAssistantButton(type: .scrollUp, action: {
                
            }),
            ScreenAssistantButton(type: .scrollDown, action: {
                
            })
        ]
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottom) {
                
                VStack(alignment: .center) {
                    TextField("", text: $addWordVM.searchText)
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                        .font(AppFontFamily.Pretendard.extraBold.swiftUIFont(size: 26))
                        .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
                        .tint(AppAsset.Colors.primaryText.swiftUIColor)
                        .multilineTextAlignment(.center)
                        .background(.clear)
                        .focused($focusField, equals: .wordField)
                        .onAppear { focusField = .wordField }
                        .onTapGesture {
                            // 검색 필드에 포커스가 유지됨
                            focusField = .wordField
                        }
                    
                    Divider().padding(.horizontal, 16)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(addWordVM.categories, id: \.title) { category in
                                Button(action: {
                                    addWordVM.categorySelection = category.title
                                }) {
                                    TagView(
                                        title: category.title.rawValue,
                                        titleColor: category.titleColor,
                                        backgroundColor: category.backgroundColor
                                    )
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.leading, 16)
                    }
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(addWordVM.searchResults, id: \.id) { result in
                                WordListItemView(word: result, searchTerm: addWordVM.searchText)
                                    .onAppear {
                                        if result == addWordVM.searchResults.last {
                                            addWordVM.loadMoreIfNeeded(currentItem: addWordVM.searchResults.last)
                                        }
                                    }
                            }
                            if addWordVM.isShowProgressView {
                                ProgressView().foregroundStyle(.gray).frame(maxWidth: .infinity, minHeight: 60)
                            }
                        }
                        .padding(16)
                    }
                    .frame(maxWidth: .infinity)
                    .simultaneousGesture(
                        DragGesture().onChanged { _ in
                            UIApplication.shared.endEditing(true)
                        }
                    )
                }
                
                ScreenAssistantView(
                     leftButtons: [],
                     centerButtons: isDidShowKeyboard ? leftToolbarButtons() : centerToolbarButtons(),
                     rightButtons: []
                )
                .onChange(of: keyboardObserver.isKeyboardVisible) { oldValue, newValue in
                    isDidShowKeyboard = newValue
                }
                
            }
            .background(.white)
             .onTapGesture {
                UIApplication.shared.endEditing(true)
             }
            
        }
        
    }
}

#Preview {
    MainView()
}
