import Foundation
import Utility
public struct APIClient {
    public init() {}

    public func request() -> String {
        "response \(Echo.run(number: 1))"
    }
}
