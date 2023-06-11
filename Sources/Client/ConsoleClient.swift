import Foundation

public struct ConsoleClient {
    public var log: (_ text: String) -> Void
}

public extension ConsoleClient {
    static let live: Self = {
        .init { text in
            print(text)
        }
    }()
}
