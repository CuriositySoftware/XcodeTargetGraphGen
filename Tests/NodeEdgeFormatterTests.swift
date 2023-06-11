import XCTest
@testable import Value
@testable import Mermaid

final class NodeEdgeFormatterTests: XCTestCase {

    func testFormat() {
        XCTAssertEqual(
            NodeEdgeFormatter()(
                node: "Native",
                connectedNode: "A"
            ),
            """
            Native --> A

            """
        )
    }

    func testFormatWithEmptyArray() {
        XCTAssertEqual(
            NodeEdgeFormatter()(
                node: "Native",
                connectedNode: ""
            ),
            "Native --> \n"
        )
    }

    func testFormatWithNonUniqueIDs() {
        XCTAssertEqual(
            NodeEdgeFormatter()(
                node: "",
                connectedNode: ""
            ),
            " --> \n"
        )
    }
}
