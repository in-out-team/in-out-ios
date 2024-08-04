import SwiftUI

struct GuidanceData: Identifiable {
    let id: Int
    let color: Color
    var subColor: Color? = nil
    let backgroundImage: Image
    var objectImage: Image? = nil
    let nextButtonImage: Image
    
    let title: String
    let description: String
    var subDescription: String? = ""
    
    
    static let list: [GuidanceData] = [
        GuidanceData(
            id: 0,
            color: AppAsset.Colors.primaryPurpleBG.swiftUIColor,
            subColor: AppAsset.Colors.primaryBlueBG.swiftUIColor,
            backgroundImage: Image(asset: AppAsset.Images.backgroundImage1),
            nextButtonImage: Image(asset: AppAsset.Images.nextButtonFilled),
            title: AppStrings.Guidance.First.title,
            description: AppStrings.Guidance.First.description,
            subDescription: AppStrings.Guidance.First.subDescription
        ),
        GuidanceData(
            id: 1,
            color: AppAsset.Colors.primaryOrangeBG.swiftUIColor,
            backgroundImage: Image(asset: AppAsset.Images.backgroundImage2),
            nextButtonImage: Image(asset: AppAsset.Images.nextButtonSecond),
            title: AppStrings.Guidance.Second.title,
            description: AppStrings.Guidance.Second.description
        ),
        GuidanceData(
            id: 2,
            color: AppAsset.Colors.primaryBlueBG.swiftUIColor,
            backgroundImage: Image(asset: AppAsset.Images.backgroundImage3),
            nextButtonImage: Image(asset: AppAsset.Images.nextButtonThrid),
            title: AppStrings.Guidance.Third.title,
            description: AppStrings.Guidance.Third.description
        ),
        GuidanceData(
            id: 3,
            color: AppAsset.Colors.primaryMintBG.swiftUIColor,
            backgroundImage: Image(asset: AppAsset.Images.backgroundImage4),
            nextButtonImage: Image(asset: AppAsset.Images.nextButtonFourth),
            title: AppStrings.Guidance.Fourth.title,
            description: AppStrings.Guidance.Fourth.description
        ),
    ]
}

struct GuidanceItem: View {
    var data: GuidanceData
    
    var body: some View {
        VStack(spacing: 0) {

            data.backgroundImage
                .resizable()
                .frame(width: 342, height: 426)
                .padding(.top, 12)
            
            VStack(spacing: 0) {
                Text(data.title)
                    .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 30))
                    .foregroundColor(data.color)
                    .multilineTextAlignment(.center)
                    .padding(.top, 21)
                
                Text(data.description)
                    .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 20))
                    .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 22)
                
                if let subDescription = data.subDescription {
                    Text(subDescription)
                        .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 14))
                        .foregroundColor(data.subColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct PageControl: View {
    @Binding var currentPage: Int
    
    var data: GuidanceData
    var numberOfPages: Int
    var pageChangeAction: (Int) -> Void
    var onCompleteGuidance: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            
            HStack(spacing: 6) {
                ForEach(0..<numberOfPages, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage
                              ? data.color
                              : AppAsset.Colors.primaryLightGrayBG.swiftUIColor
                        )
                        .frame(width: index == currentPage ? 24 : 10, height: 10)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                        .onTapGesture {
                            withAnimation { currentPage = index }
                        }
                }
            }
            
            Spacer()
            
            HStack(spacing: 0) {
                
                Button(action: {
                    withAnimation {
                        if currentPage > 0 {
                            pageChangeAction(currentPage - 1)
                        }
                    }
                }) {
                    Image(asset: AppAsset.Images.previousButton)
                        .resizable()
                        .frame(width: 64, height: 64)
                }.buttonStyle(.plain)
                
                Button(action: {
                    withAnimation {
                        if currentPage < numberOfPages - 1 {
                            pageChangeAction(currentPage + 1)
                        } else {
                            onCompleteGuidance()
                        }
                    }
                }) {
                    data.nextButtonImage
                        .resizable()
                        .frame(width: 64, height: 64)
                }.buttonStyle(.plain)
                
            }
            
        }
        .padding(.leading, 40)
        .padding(.trailing, 24)
    }
}

struct GuidanceView: View {
    @EnvironmentObject private var onBoarding: OnBoardingVM
    @State private var currentTab = 0
    
    var body: some View {
        
        SafeAreaInsetView(alignment: .center) {
            
            VStack(spacing: 0) {
                TabView(selection: $currentTab) {
                    ForEach(GuidanceData.list) { viewData in
                        GuidanceItem(data: viewData).tag(viewData.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                PageControl(
                    currentPage: $currentTab,
                    data: GuidanceData.list[currentTab],
                    numberOfPages: GuidanceData.list.count,
                    pageChangeAction: { newIndex in
                        withAnimation { currentTab = newIndex }
                    },
                    onCompleteGuidance: onBoarding.onCompleteGuidance
                )
                
            }
            
        }
        .background(.white)
        
    }
}

#Preview {
    GuidanceView().environmentObject(OnBoardingVM())
}
