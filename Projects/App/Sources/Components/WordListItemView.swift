import SwiftUI

struct WordListItemView: View {
    let word: Components.Schemas.WordWithDefinitionsResponse
    let searchTerm: String
    let firstDefinition: Components.Schemas.WordDefinitionResponse?
    
    init(word: Components.Schemas.WordWithDefinitionsResponse, searchTerm: String) {
        self.word = word
        self.searchTerm = searchTerm
        self.firstDefinition = word.definitions.first
    }
    
    private func tagColor(for lexicalCategory: Components.Schemas.WordDefinitionResponse.lexicalCategoryPayload) 
    -> (Color, Color) {
        switch lexicalCategory {
        case .NOUN:
            return (
                AppAsset.Colors.primaryOrangeText.swiftUIColor,
                AppAsset.Colors.secondaryOrangeBG.swiftUIColor
            )
        case .VERB:
            return (
                AppAsset.Colors.primaryPurpleText.swiftUIColor,
                AppAsset.Colors.secondaryPurpleBG.swiftUIColor
            )
        case .ADJECTIVE:
            return (
                AppAsset.Colors.primaryBlueText.swiftUIColor,
                AppAsset.Colors.secondaryBlueBG.swiftUIColor
            )
        case .ADVERB:
            return (
                AppAsset.Colors.primaryDarkPurpleText.swiftUIColor,
                AppAsset.Colors.secondaryDarkPurpleBG.swiftUIColor
            )
            
            // TODO: 색상 정의
        case .PRONOUN:
            return (.gray, .gray)
        case .PREPOSITION:
            return (.gray, .gray)
        case .CONJUNCTION:
            return (.gray, .gray)
        case .INTERJECTION:
            return (.gray, .gray)
        case .UNKNOWN:
            return (.gray, .gray)
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                highlightSearchTerm(text: word.name, searchTerm: searchTerm)
                
                VStack(spacing: 2) {
                    Text(firstDefinition?.preContext ?? "")
                        .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 14))
                        .foregroundColor(AppAsset.Colors.tertiaryText.swiftUIColor)
                        .frame(maxWidth: .infinity, alignment: .leading)  // 텍스트를 왼쪽 정렬
                    
                    Text(firstDefinition?.meaning ?? "")
                        .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 16))
                        .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
                        .frame(maxWidth: .infinity, alignment: .leading)  // 텍스트를 왼쪽 정렬
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 0)
            
            if let lexicalCategory = firstDefinition?.lexicalCategory {
                Text(lexicalCategory.rawValue.capitalizedFirstLetter())
                    .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 10))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .foregroundColor(tagColor(for: lexicalCategory).0)
                    .background(tagColor(for: lexicalCategory).1)
                    .cornerRadius(6)
                    .padding([.top, .trailing], 12)
            }
        }
    }
    
    @ViewBuilder
    private func highlightSearchTerm(text: String, searchTerm: String) -> some View {
        if let range = text.lowercased().range(of: searchTerm.lowercased()) {
            let prefix = text[text.startIndex..<range.lowerBound]
            let match = text[range]
            let suffix = text[range.upperBound..<text.endIndex]
            
            let text = Text(prefix).foregroundColor(AppAsset.Colors.secondaryText.swiftUIColor)
            + Text(match).foregroundColor(AppAsset.Colors.primaryPurpleText.swiftUIColor)
            + Text(suffix).foregroundColor(AppAsset.Colors.secondaryText.swiftUIColor)
            
            text.font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 20))
        } else {
            Text(text)
        }
    }
}
