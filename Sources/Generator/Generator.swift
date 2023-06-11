import Foundation
import Client
import XcodeProj
import PathKit
import Mermaid

public struct Generator {
    public func run(
        projectFilePath: String,
        outputFilePath: String,
        mermaidTheme: String,
        mermaidSyntaxType: String,
        mermaidChartDirection: String,
        swiftPackageOutput: Bool = true,
        appleSDKOutput: Bool = false,
        carthageOutput: Bool = true,
        cocoaPodsOutput: Bool = true,
        vendorOutput: Bool = true,
        dryRun: Bool
    ) throws {
        let console = ConsoleClient.live

        console.log("🚀 Reading \(projectFilePath) ...")
        let xcodeProj = try XcodeProj(path: Path(projectFilePath))

        console.log("🤖 Analyzing .xcodeproj ...")
        let project = ProjectMaker().makeProject(from: xcodeProj)

        console.log("🧜 Generating graph in Mermaid syntax ...")
        let text = MermaidFormatter().format(
            with: project,
            mermaidTheme: mermaidTheme,
            syntaxType: .init(
                type: mermaidSyntaxType,
                direction: mermaidChartDirection
            ),
            swiftPackageOutput: swiftPackageOutput,
            appleSDKOutput: appleSDKOutput,
            carthageOutput: carthageOutput,
            cocoaPodsOutput: cocoaPodsOutput,
            vendorOutput: vendorOutput
        )

        console.log("📄 Starting to create file at \(Path(outputFilePath).absolute()) ...")
        if dryRun {
            console.log(text)
        } else {
            try FileOutputClient.live.write(text, Path(outputFilePath).url)
        }

        console.log("✅ Created")
    }

    public init() {}
}
