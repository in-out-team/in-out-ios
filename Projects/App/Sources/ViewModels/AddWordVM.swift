import SwiftUI
import Foundation

enum CategoryName: String {
    case All = "All"
    case Verb = "Verb"
    case Noun = "Noun"
    case Adjective = "Adjective"
    case Adverb = "Adverb"
}

struct Category {
    let title: CategoryName
    let titleColor: Color
    let backgroundColor: Color
}

class AddWordVM: ObservableObject {
    @Published var categorySelection = CategoryName.All
    @Published var word = ""
    
    enum Field: Hashable {
        case wordField
    }
    
    let categories: [Category] = [
        .init(
            title: .All,
            titleColor: AppAsset.Colors.secondaryText.swiftUIColor,
            backgroundColor: AppAsset.Colors.primaryLightGrayBG.swiftUIColor
        ),
        .init(
            title: .Verb,
            titleColor: AppAsset.Colors.primaryPurpleText.swiftUIColor,
            backgroundColor: AppAsset.Colors.secondaryPurpleBG.swiftUIColor
        ),
        .init(
            title: .Noun,
            titleColor: AppAsset.Colors.primaryOrangeText.swiftUIColor,
            backgroundColor: AppAsset.Colors.secondaryOrangeBG.swiftUIColor
        ),
        .init(
            title: .Adjective,
            titleColor: AppAsset.Colors.primaryBlueText.swiftUIColor,
            backgroundColor: AppAsset.Colors.secondaryBlueBG.swiftUIColor
        ),
        .init(
            title: .Adverb,
            titleColor: AppAsset.Colors.primaryDarkPurpleText.swiftUIColor,
            backgroundColor: AppAsset.Colors.secondaryDarkPurpleBG.swiftUIColor
        ),
    ]
}
