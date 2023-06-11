import Foundation

public enum SyntaxType {
    public enum ChartDirection {
        case topDown
        case bottomUp

        public init(direction: String) {
            switch direction {
            case "TD":
                self = .topDown

            case "BU":
                self = .bottomUp

            default:
                self = .topDown
            }
        }
    }

    case graph(ChartDirection)
    case flowchart(ChartDirection)

    public init(type: String, direction: String) {
        switch type {
        case "graph":
            self = .graph(ChartDirection(direction: direction))

        case "flowchart":
            self = .flowchart(ChartDirection(direction: direction))

        default:
            self = .graph(ChartDirection(direction: direction))
        }
    }
}
