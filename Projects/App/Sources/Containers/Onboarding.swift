//
//  Onboarding.swift
//  App
//
//  Created by kwh on 7/1/24.
//

import SwiftUI

struct Onboarding: View {
    public init() {
        
    }
    
    var attributedString: AttributedString {
        var attributedString = AttributedString(AppStrings.SignIn.Title.Third.full)
        
        if let range = attributedString.range(of: AppStrings.SignIn.Title.Third.plain) {
            attributedString[range].foregroundColor = AppAsset.Colors.primaryText.swiftUIColor
        }
        
        if let range = attributedString.range(of: AppStrings.SignIn.Title.Third.highlight) {
            attributedString[range].foregroundColor = AppAsset.Colors.textHighlightBlue.swiftUIColor
        }
        
        return attributedString
    }
    
    public var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                ZStack() {
                    Circle()
                        .fill(AppAsset.Colors.primaryPurple.swiftUIColor)
                        .frame(width: 160, height: 160)
                        .position(x: 101, y: 151)
                        .opacity(0.8)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryMint.swiftUIColor)
                        .frame(width: 148, height: 148)
                        .position(x: geometry.size.width - 84, y: 80)
                        .opacity(0.8)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryGray.swiftUIColor)
                        .frame(width: 100, height: 100)
                        .position(x: 236, y: 198)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryRed.swiftUIColor)
                        .frame(width: 180, height: 180)
                        .position(x: geometry.size.width - 10, y: 254)
                        .opacity(0.6)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryOrange.swiftUIColor)
                        .frame(width: 148, height: 148)
                        .position(x: 10, y: 294)
                        .opacity(0.8)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryGray.swiftUIColor)
                        .frame(width: 220, height: 220)
                        .position(x: 196, y: 364)
                    
                    Circle()
                        .fill(AppAsset.Colors.primaryBlue.swiftUIColor)
                        .frame(width: 148, height: 148)
                        .position(x: geometry.size.width - 8, y: 436)
                        .opacity(0.8)
                    
                    
                    VStack(alignment: .leading) {
                        Text(AppStrings.SignIn.Title.first)
                            .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
                            .foregroundColor(AppAsset.Colors.primaryText.swiftUIColor)
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            Text(AppStrings.SignIn.Title.second)
                                .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 36))
                                .foregroundColor(AppAsset.Colors.textHighlightPurple.swiftUIColor)
                            
                            Text(attributedString)
                                .font(AppFontFamily.Pretendard.semiBold.swiftUIFont(size: 28))
                                .foregroundColor(AppAsset.Colors.textHighlightBlue.swiftUIColor)
                        }
                        
                    }.position(x: geometry.size.width / 2, y: 550)
                    
                }.background(.white)
                
                VStack(spacing: 28) {
                    
                    Text(AppStrings.SignIn.subtitle)
                        .font(AppFontFamily.Pretendard.medium.swiftUIFont(size: 14))
                        .foregroundColor(AppAsset.Colors.textHighlightMint.swiftUIColor)
                    
                    HStack(spacing: 12) {
                        Image(asset: AppAsset.Images.kakaoAuthImage)
                            .resizable()
                            .frame(width: 54, height: 54)
                        Image(asset: AppAsset.Images.googleAuthImage)
                            .resizable()
                            .frame(width: 54, height: 54)
                        Image(asset: AppAsset.Images.appleAuthImage)
                            .resizable()
                            .frame(width: 54, height: 54)
                    }
                    
                }.frame(maxWidth: .infinity).padding(.bottom, 24).background(.white)
                
            }
            
        }
        
    }
}

#Preview {
    Onboarding()
}
