import Foundation
import ArgumentParser
import Generator

@main
struct XcodeTargetGraphGenCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "xcgraphgen",
        abstract: "Output Xcode Target Dependency Graph.",
        discussion: """
        """,
        version: "1.0.0",
        shouldDisplay: true,
        helpNames: [.long, .short]
    )

    @Argument(help: ".xcodeproj file path.")
    var projectFilePath: String

    @Option(help: "Output file path.")
    var outputFilePath: String = "./dependencies.md"

    @Option(help: "Select Mermaid theme type (eg: neutral, forest, dark, base).")
    var mermaidTheme = "dark"

    @Option(help: "Select Mermaid syntax type.")
    var mermaidSyntaxType = "flowchart"

    @Option(help: "Select Mermaid graph/flowchart direction.")
    var mermaidChartDirection = "TD"

    @Flag(
        inversion: FlagInversion.prefixedEnableDisable,
        help: "Targeting Swift Package Product for output."
    )
    var swiftPackageOutput = true

    @Flag(
        inversion: FlagInversion.prefixedEnableDisable,
        help: "Targeting Apple SDKs for output."
    )
    var appleSDKOutput = false

    @Flag(
        inversion: FlagInversion.prefixedEnableDisable,
        help: "Targeting Carthage for output."
    )
    var carthageOutput = true

    @Flag(
        inversion: FlagInversion.prefixedEnableDisable,
        help: "Targeting CocoaPods SDKs for output (only old format without .xcfilelist)."
    )
    var cocoaPodsOutput = true

    @Flag(
        inversion: FlagInversion.prefixedEnableDisable,
        help: "Targeting vendor project for output."
    )
    var vendorOutput = false

    @Flag(help: "Output to console without file output")
    var dryRun = false

    mutating func run() throws {
        try Generator().run(
            projectFilePath: projectFilePath,
            outputFilePath: outputFilePath,
            mermaidTheme: mermaidTheme,
            mermaidSyntaxType: mermaidSyntaxType,
            mermaidChartDirection: mermaidChartDirection,
            swiftPackageOutput: swiftPackageOutput,
            appleSDKOutput: appleSDKOutput,
            carthageOutput: carthageOutput,
            cocoaPodsOutput: cocoaPodsOutput,
            vendorOutput: vendorOutput,
            dryRun: dryRun
        )
    }

    mutating func validate() throws {}
}
