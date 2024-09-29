import SwiftUI
import Foundation
import Combine

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

struct PaginationSearchWord: Codable {
    let data: [Components.Schemas.WordWithDefinitionsResponse]
    let hasMore: Bool
    let count: Int
}

class AddWordVM: ObservableObject {
    @Published var categorySelection = CategoryName.All
    @Published var searchText = ""
    @Published var searchResults: [Components.Schemas.WordWithDefinitionsResponse] = []
    @Published var isShowProgressView = false
    
    var hasMore = false
    var count = 0
    
    var currentPage = 0
    var searchCache: [String: (results: [Components.Schemas.WordWithDefinitionsResponse], lastPage: Int)] = [:]
    
    private var isLoading = false {
        didSet {
            DispatchQueue.main.async {
                self.isShowProgressView = self.isLoading
            }
        }
    }
    
    private let pageSize = 10
    
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
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        APIService.shared.delegate = self
        
        Publishers.CombineLatest(
            $searchText.removeDuplicates(),
            $categorySelection
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] newWord, newCategory in
            guard let self = self else { return }
            
            // 페이지 초기화 및 플래그 초기화
            self.resetSearchResult()
            
            let cacheKey = self.createCacheKey(category: newCategory, searchText: newWord)
            
            // 캐시 확인
            if let cachedData = self.searchCache[cacheKey], !newWord.isEmpty {
                self.searchResults = cachedData.results
                self.currentPage = cachedData.lastPage
                self.hasMore = cachedData.results.count >= self.pageSize
            } else {
                self.searchWord(
                    searchText: newWord,
                    category: newCategory,
                    page: self.currentPage
                )
            }
            
        }
        .store(in: &cancellables)
    }
    
    private func createCacheKey(category: CategoryName, searchText: String) -> String {
        return "\(category.rawValue)_\(searchText)"
    }
    
    private func searchWord(
        searchText: String,
        category: CategoryName,
        page: Int
    ) {
        guard !searchText.isEmpty else { return }
        
        let cacheKey = self.createCacheKey(category: category, searchText: searchText)
        
        let queryParams: [String: String] = {
            var params: [String: String] = [
                "fromLanguage": "ENGLISH",
                "toLanguage": "KOREAN",
                "prefix": searchText,
                "page": "\(page)",
                "size": "\(pageSize)",
            ]
            
            if category != .All {
                params["lexicalCategory"] = category.rawValue.uppercased()
            }
            
            return params
        }()
        
        self.isLoading = true
        Task {
            let result: Result<PaginationSearchWord, NetworkError> = await APIService.shared.fetch(
                .GET,
                "/words/definitions",
                queryParams,
                nil
            )
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if page == 0 {
                        self.searchResults = response.data
                    } else {
                        self.searchResults.append(contentsOf: response.data)
                    }
                    
                    // 캐시에 저장 (결과 및 마지막 페이지)
                    self.searchCache[cacheKey] = (results: self.searchResults, lastPage: page)
                    
                    self.hasMore = response.hasMore
                    self.count = response.count
                }
                
            case .failure(let errorType):
                // 오류 처리
                print("Error: \(errorType)")
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func loadMoreIfNeeded(currentItem: Components.Schemas.WordWithDefinitionsResponse?) {
        guard let currentItem = currentItem, !isLoading, hasMore else { return }
        
        let thresholdIndex = searchResults.index(searchResults.endIndex, offsetBy: -1)
        if searchResults.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            currentPage += 1
            searchWord(
                searchText: searchText,
                category: categorySelection,
                page: currentPage
            )
        }
    }
    
    func resetSearchResult() {
        currentPage = 0
        searchResults.removeAll()
    }
}

extension AddWordVM: APIServiceDelegate {
    func onLoading(path: String?, isLoading: Bool) {
        guard let path else { return }
        
        if path == "/words/definitions" {
            self.isLoading = isLoading
        }
    }
}
