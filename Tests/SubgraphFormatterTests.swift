import XCTest
@testable import Mermaid

final class SubgraphFormatterTests: XCTestCase {

    func testFormat() throws {
        XCTAssertEqual(
            SubgraphFormatter()(
                groupName: "TestGroup",
                dependencies: [
                    "ID1",
                    "ID2"
                ]
            ),
            """
            subgraph TestGroup
            ID1["ID1"]
            ID2["ID2"]
            end

            """
        )
    }

    func testFormatWithEmptyArray() throws {
        let array: [String] = []

        XCTAssertEqual(
            SubgraphFormatter()(
                groupName: "TestGroup",
                dependencies: array
            ),
            """
            subgraph TestGroup
            end

            """
        )
    }

    func testFormatWithNonUniqueIDs() {
        XCTAssertEqual(
            SubgraphFormatter()(
                groupName: "TestGroup",
                dependencies: [
                    "ID1",
                    "ID1"
                ]
            ),
            """
            subgraph TestGroup
            ID1["ID1"]
            ID1["ID1"]
            end

            """
        )
    }
}
