import XCTest
import Client

final class FileOutputClientTests: XCTestCase {

    private var fileOutputClient: FileOutputClient!
    private var testFileURL: URL!

    override func setUp() {
        super.setUp()
        fileOutputClient = FileOutputClient.live
        let directory = FileManager.default.temporaryDirectory
        testFileURL = directory.appendingPathComponent("testFile.txt")
    }

    override func tearDownWithError() throws {
        super.tearDown()
        try FileManager.default.removeItem(at: testFileURL)
    }

    func testWrite() throws {
        try fileOutputClient.write("Hello, World!", testFileURL)

        XCTAssertEqual(
            try String(contentsOf: testFileURL, encoding: .utf8),
            "Hello, World!"
        )
    }
}
