import SwiftUI
import Foundation

enum TabName: CaseIterable {
    case HOME
    case TALK_TO_AI
    case SETTING
}

struct Tab {
    let screen: AnyView
    let name: TabName
    let icon: Image
    let selectedIcon: Image
    let iconSize: CGSize
}

class MainVM: ObservableObject {
    @Published var tabSelection = TabName.HOME
    
    let tabs: [TabName: Tab] = [
        .HOME: Tab(
            screen: AnyView(HomeView()),
            name: .HOME,
            icon: Image(asset: AppAsset.Images.cardsGray),
            selectedIcon: Image(asset: AppAsset.Images.cardsWhite),
            iconSize: .init(width: 36, height: 36)
        ),
        .TALK_TO_AI: Tab(
                screen: AnyView(TalkToAiView()),
                name: .TALK_TO_AI,
                icon: Image(asset: AppAsset.Images.talkToAiGray),
                selectedIcon: Image(asset: AppAsset.Images.talkToAiWhite),
                iconSize: .init(width: 42, height: 36)
        ),
        .SETTING: Tab(
                screen: AnyView(SettingView()),
                name: .SETTING,
                icon: Image(asset: AppAsset.Images.settingGray),
                selectedIcon: Image(asset: AppAsset.Images.settingWhite),
                iconSize: .init(width: 26, height: 26)
        )
    ]
}
