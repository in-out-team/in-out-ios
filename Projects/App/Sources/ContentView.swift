import SwiftUI

public struct ContentView: View {
    public init() {}
    
    
    
    public var body: some View {
        Text("\(Config.appEnv)-\(Config.buildEnv)")
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         ContentView()
    }
}
