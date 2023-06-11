import Foundation

public struct FileListReaderClient {
    public var read: (_ fileURL: URL) throws -> [String]
}

public extension FileListReaderClient {
    static let live: Self = {
        .init { url in
            let content = try String(contentsOf: url, encoding: .utf8)
            return content.split(separator: "\n").map(String.init)
        }
    }()
}
