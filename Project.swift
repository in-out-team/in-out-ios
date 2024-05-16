import ProjectDescription

let project = Project(
    name: "InOutIos",
    targets: [
        .target(
            name: "InOutIos",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.InOutIos",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["InOutIos/Sources/**"],
            resources: ["InOutIos/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "InOutIosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.InOutIosTests",
            infoPlist: .default,
            sources: ["InOutIos/Tests/**"],
            resources: [],
            dependencies: [.target(name: "InOutIos")]
        ),
    ]
)
