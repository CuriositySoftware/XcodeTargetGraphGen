import Foundation

public protocol NodeIdentifiable {
    var id: String { get }
    var name: String { get }
}

public struct Project {
    public struct Native: Equatable, NodeIdentifiable {
        public let id: String
        public let name: String
        public let targetDependencies: [Target]
        public let packageProductDependencies: [SwiftPackage]
        public let otherDependencies: [Framework]

        public init(
            id: String,
            name: String,
            targetDependencies: [Target],
            packageProductDependencies: [SwiftPackage],
            otherDependencies: [Framework]
        ) {
            self.id = id
            self.name = name
            self.targetDependencies = targetDependencies
            self.packageProductDependencies = packageProductDependencies
            self.otherDependencies = otherDependencies
//            otherDependencies.forEach {
//                print("dependency:", $0.type, $0.name, $0.id)
//
//                if $0.type == .pods {
//                }
//            }
        }

        public static func == (lhs: Native, rhs: Native) -> Bool {
            return lhs.id == rhs.id
        }
    }

    public struct Target: Identifiable, Hashable, NodeIdentifiable {
        public var id: String
        public let name: String

        public init(id: String, name: String) {
            self.id = id
            self.name = name
        }
    }

    public struct Framework: Identifiable, Hashable, NodeIdentifiable {
        public enum FrameworkType {
            // Apple SDK
            case platformSDK
            // Carthage
            case carthage
            // Pods
            case pods
            case vendor
        }

        public var id: String
        public let name: String
        public let type: FrameworkType

        public init(id: String, name: String, type: FrameworkType) {
            self.id = id
            self.name = name
            self.type = type
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public static func == (lhs: Framework, rhs: Framework) -> Bool {
            return lhs.id == rhs.id
        }
    }

    public struct SwiftPackage: Identifiable, Hashable, NodeIdentifiable {
        public enum DependencyType: Hashable {
            case remote(urlString: String)
            case local
        }

        public static func == (lhs: Project.SwiftPackage, rhs: Project.SwiftPackage) -> Bool {
            lhs.id == rhs.id
        }

        public var id: String
        public let name: String
        public let type: DependencyType

        public init(
            id: String,
            name: String,
            type: DependencyType
        ) {
            self.id = id
            self.name = name
            self.type = type
        }
    }


    public let name: String
    public let nativeTargets: [Native]

    public init(name: String, nativeTargets: [Native] = []) {
        self.name = name
        self.nativeTargets = nativeTargets
    }
}
