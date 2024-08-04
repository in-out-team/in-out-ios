import SwiftUI

struct CustomTabsView: View {
    @Binding var tabSelection: TabName
    @Namespace private var animationNamespace
    
    let tabs: [TabName: Tab]
    
    var body: some View {
        ZStack {
            
            Capsule()
                .frame(width: 190, height: 66)
                .foregroundColor(AppAsset.Colors.primaryGrayBG.swiftUIColor)
                .opacity(0.2)
            
            HStack(spacing: 6) {
                ForEach(TabName.allCases, id: \.self) { tabName in
                    if let tab = tabs[tabName] {
                        Button(action: { tabSelection = tab.name }) {
                            ZStack {
                                if tab.name == tabSelection {
                                    Circle()
                                        .fill(AppAsset.Colors.primaryPurpleBG.swiftUIColor)
                                        .frame(width: 54, height: 54)
                                        // .matchedGeometryEffect(
                                        //    id: "SelectedTabId",
                                        //    in: animationNamespace
                                        // )
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 54, height: 54)
                                }
                                
                                (tab.name == tabSelection ? tab.selectedIcon : tab.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(
                                        width: tab.iconSize.width,
                                        height: tab.iconSize.height
                                    )
                                    .offset(
                                        x: tab.offset?.x ?? 0,
                                        y: tab.offset?.y ?? 0
                                    )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
        }
    }
}

struct MainView: View {
    @StateObject private var mainVM = MainVM()
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack {
                mainVM.tabs[mainVM.tabSelection]?.screen
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabsView(
                tabSelection: $mainVM.tabSelection,
                tabs: mainVM.tabs
            )
        }
        .background(.white)
        
    }
}

#Preview {
    MainView()
}
