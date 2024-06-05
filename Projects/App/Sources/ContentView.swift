import SwiftUI

public struct ContentView: View {
    public init() {
        
    }
    
    
    
    public var body: some View {
        VStack {
            Image(asset: AppAsset.Assets.testIcon)
            
            Text(AppStrings.Common.appName)
                .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 20))
            
            Text("\(Config.appEnv)-\(Config.buildEnv)")
                .padding()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         ContentView()
    }
}
