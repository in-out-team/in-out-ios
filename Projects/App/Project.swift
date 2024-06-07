import ProjectDescription

extension ConfigurationName {
    static var developmentDebug: ConfigurationName {
        ConfigurationName("DevelopmentDebug")
    }
    static var developmentRelease: ConfigurationName {
        ConfigurationName("DevelopmentRelease")
    }
    static var productionDebug: ConfigurationName {
        ConfigurationName("ProductionDebug")
    }
    static var productionRelease: ConfigurationName {
        ConfigurationName("ProductionRelease")
    }
}

let configurations: [Configuration] = [
    .debug(
        name: .developmentDebug,
        settings: SettingsDictionary()
            .manualCodeSigning(identity: "Apple Development", provisioningProfileSpecifier: "inout-debug")
            .otherSwiftFlags(["-DDEV_DEBUG"]),
        xcconfig: "Configurations/development.xcconfig"
    ),
    .debug(
        name: .productionDebug,
        settings: SettingsDictionary()
            .manualCodeSigning(identity: "Apple Development", provisioningProfileSpecifier: "inout-debug")
            .otherSwiftFlags(["-DPROD_DEBUG"]),
        xcconfig: "Configurations/production.xcconfig"
    ),
    .release(
        name: .developmentRelease,
        settings: SettingsDictionary()
            .manualCodeSigning(identity: "Apple Distribution", provisioningProfileSpecifier: "inout-release")
            .otherSwiftFlags(["-DDEV_RELEASE"]),
        xcconfig: "Configurations/development.xcconfig"
    ),
    .release(
        name: .productionRelease,
        settings: SettingsDictionary()
            .manualCodeSigning(identity: "Apple Distribution", provisioningProfileSpecifier: "inout-release")
            .otherSwiftFlags(["-DPROD_RELEASE"]),
        xcconfig: "Configurations/production.xcconfig"
    )
]

let settings: Settings = .settings(
    base: SettingsDictionary().merging(["DEVELOPMENT_TEAM": "DQNSTQBH74"]),
    configurations: configurations,
    defaultSettings: .recommended(excluding: ["CODE_SIGN_IDENTITY"])
)

let xcconfig: [String: Plist.Value] = [
    "APP_ENV": "$(APP_ENV)"
]

let basePlist: [String: Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen",
    "ITSAppUsesNonExemptEncryption": false
]

let runActionOptions = RunActionOptions.options(
    language: "en", // or "ko"
    region: "KR" // or "US"
)

let project = Project(
    name: "App",
    options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["ko", "en"],
        developmentRegion: "en"
        // textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
    ),
    // packages: [], Xcode Tool SPM
    packages: [
        .package(url: "https://github.com/apple/swift-openapi-generator", .upToNextMinor(from: "1.2.1")),
        .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "1.4.0")),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMinor(from: "1.0.1")),
        
        .package(url: "https://github.com/splinetool/spline-ios", .branch("main"))
    ],
    settings: settings,
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "io.inout-team.inout",
            infoPlist: .extendingDefault(
                with: basePlist.merging(xcconfig, uniquingKeysWith: { $1 })
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "SplineRuntime"),
        
                .package(product: "OpenAPIGenerator", type: .plugin),
                .package(product: "OpenAPIRuntime"),
                .package(product: "OpenAPIURLSession")
            ]
        ),
        .target(
            name: "AppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.AppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "App")]
        ),
    ],
    schemes: [
        .scheme(
            name: "development",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            runAction: .runAction(
                configuration: .developmentDebug,
                options: runActionOptions
            ),
            archiveAction: .archiveAction(configuration: .developmentRelease)
        ),
        .scheme(
            name: "production",
            shared: true,
            buildAction: .buildAction(targets: ["App"]),
            runAction: .runAction(
                configuration: .productionDebug,
                options: runActionOptions
            ),
            archiveAction: .archiveAction(configuration: .productionRelease)
        )
    ]
)
