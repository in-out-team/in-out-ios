import ProjectDescription

let workspace = Workspace(
    name: "Workspace",
    projects: ["Projects/**"],
    generationOptions: .options(
        autogeneratedWorkspaceSchemes: .disabled
    )
)
