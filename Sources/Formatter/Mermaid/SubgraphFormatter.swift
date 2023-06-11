import Foundation

import Value

struct SubgraphFormatter {
    func callAsFunction(
        groupName: String,
        dependencies: [String]
    ) -> String {
        """
        subgraph \(groupName)
        \(dependencies.reduce("") { result, dependency in
            result + "\(dependency)[\"\(dependency)\"]\n"
        })end

        """
    }
}
