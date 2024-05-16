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
    .debug(name: .developmentDebug, settings: SettingsDictionary()
        .manualCodeSigning(identity: "Apple Development", provisioningProfileSpecifier: "inout-debug")
    ),
    .debug(name: .productionDebug, settings: SettingsDictionary()
        .manualCodeSigning(identity: "Apple Development", provisioningProfileSpecifier: "inout-debug")
    ),
    .release(name: .developmentRelease, settings: SettingsDictionary()
        .manualCodeSigning(identity: "Apple Distribution", provisioningProfileSpecifier: "inout-release")
    ),
    .release(name: .productionRelease, settings: SettingsDictionary()
        .manualCodeSigning(identity: "Apple Distribution", provisioningProfileSpecifier: "inout-release")
    )
]

let settings: Settings = .settings(
    // base: <#T##SettingsDictionary#>,
    configurations: configurations
    // defaultSettings: <#T##DefaultSettings#>
)

let project = Project(
    name: "App",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    settings: settings,
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "io.inout-team.inout",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
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
            buildAction: .buildAction(targets: ["App"])
            // runAction: .runAction(executable: "App")
        ),
        .scheme(
            name: "production",
            shared: true,
            buildAction: .buildAction(targets: ["App"])
            // runAction: .runAction(executable: "App")
        )
    ]
)
