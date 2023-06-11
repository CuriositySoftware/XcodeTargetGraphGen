import Foundation
import Value

struct NodeEdgeFormatter {
    func callAsFunction(
        node: String,
        connectedNode: String
    ) -> String {
        "\(node) --> \(connectedNode)\n"
    }
}
