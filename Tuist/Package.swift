// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: ["SplineRuntime": .framework]
)
#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/splinetool/spline-ios", branch: "main")
    ]
)
