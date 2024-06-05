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
            dependencies: []
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
