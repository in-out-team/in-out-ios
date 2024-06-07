import SwiftUI
import SplineRuntime

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        
        // // fetching from local
        // let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
        
        let url = URL(string: "https://build.spline.design/BI46V7-yssfMqHOjsB3z/scene.splineswift")!
        
        VStack {
            Image(asset: AppAsset.Assets.testIcon)
            Text("Image Test").padding(.bottom, 30)
            
            try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
            Text("Spline Test").padding(.top, 30)
            
            Text(AppStrings.Common.appName)
                .font(AppFontFamily.Pretendard.bold.swiftUIFont(size: 20))
                .padding(.top, 30)
            Text("\(Config.appEnv)-\(Config.buildEnv)")
                .padding()
            
            Spacer(minLength: 50)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         ContentView()
    }
}
