import Foundation
import Value
import Converter

public struct MermaidFormatter {
    public init() {}

    public func format(
        with project: Project,
        mermaidTheme: String,
        syntaxType: SyntaxType,
        swiftPackageOutput: Bool = true,
        appleSDKOutput: Bool = false,
        carthageOutput: Bool = true,
        cocoaPodsOutput: Bool = true,
        vendorOutput: Bool = true
    ) -> String {

        let representation = ProjectConverter().convert(project)

        // MARK:

        var result = "```mermaid\n"

        // MARK:

        result += "%%{init: {'theme':'\(mermaidTheme)'}}%%\n"

        // MARK:

        switch syntaxType {
        case .graph(let direction):
            switch direction {
            case .topDown:
                result += "graph TD"
            case .bottomUp:
                result += "graph BU"
            }

        case .flowchart(let direction):
            switch direction {
            case .topDown:
                result += "flowchart TD"
            case .bottomUp:
                result += "flowchart BU"
            }
        }

        result += "\n"

        if !representation.projectName.isEmpty {
            result += "style \(representation.projectName) stroke-width:4px"
        }

        result += "\n"

        // %%

        // MARK:

        let subgraph = SubgraphFormatter()

        if swiftPackageOutput, !representation.packageProducts.isEmpty {
            result += subgraph(
                groupName: "Swift Package",
                dependencies: representation.packageProducts.map(\.name)
            )
        }

        if swiftPackageOutput, !representation.localPackageProducts.isEmpty {
            result += subgraph(
                groupName: "Swift Package Local",
                dependencies: representation.localPackageProducts.map(\.name)
            )
        }

        if appleSDKOutput, !representation.appleSDKs.isEmpty {
            result += subgraph(
                groupName: "Apple SDK",
                dependencies: representation.appleSDKs.map(\.name)
            )
        }

        if carthageOutput, !representation.carthageFrameworks.isEmpty {
            result += subgraph(
                groupName: "Carthage",
                dependencies: representation.carthageFrameworks.map(\.name)
            )
        }

        if cocoaPodsOutput, !representation.podsFrameworks.isEmpty {
            result += subgraph(
                groupName: "CocoaPods",
                dependencies: representation.podsFrameworks.map(\.name)
            )
        }

        if vendorOutput, !representation.vendorFrameworks.isEmpty {
            result += subgraph(
                groupName: "Vendor",
                dependencies: representation.vendorFrameworks.map(\.name)
            )
        }

        // NOTE:
        // In Mermaid Diagram Syntax,
        // what is written first is placed on the right of the figure.
        // For this reason, the main thing is written last.
        if !representation.nativeTargets.isEmpty {
            result += subgraph(
                groupName: "Native Target",
                dependencies: representation.nativeTargets.map(\.name)
            )
        }

        // MARK:

        let formatNodeEdge = NodeEdgeFormatter()

        project.nativeTargets.forEach { native in
            result += native.targetDependencies.reduce("") { result, connectedNode in
                result + formatNodeEdge(node: native.name, connectedNode: connectedNode.name)
            }

            if swiftPackageOutput {
                result += native.packageProductDependencies.reduce("") { result, connectedNode in
                    result + formatNodeEdge(node: native.name, connectedNode: connectedNode.name)
                }
            }

            result += native.otherDependencies.filter { dependency in
                switch dependency.type {
                case .platformSDK:
                    return appleSDKOutput

                case .carthage:
                    return carthageOutput

                case .pods:
                    return cocoaPodsOutput

                case .vendor:
                    return vendorOutput
                }
            }
            .reduce("") { result, connectedNode in
                result + formatNodeEdge(node: native.name, connectedNode: connectedNode.name)
            }
        }

        return result + "```\n"
    }
}
