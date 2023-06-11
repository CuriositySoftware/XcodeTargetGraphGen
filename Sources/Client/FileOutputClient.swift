import Foundation

public struct FileOutputClient {
    public var write: (_ text: String, _ url: URL) throws -> Void
}

public extension FileOutputClient {
    static let live: Self = {
        .init { text, url in
            try text.write(to: url, atomically: true, encoding: .utf8)
        }
    }()
}
