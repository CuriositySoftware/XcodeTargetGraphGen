import Foundation
import Value

public struct FormatterRepresentation: Equatable {
    public struct NativeTarget: Equatable {
        public let id: String
        public let name: String
        public init(id: String, name: String) {
            self.id = id
            self.name = name
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    public let projectName: String
    public let nativeTargets: [NativeTarget]
    public let packageProducts: [Project.SwiftPackage]
    public let localPackageProducts: [Project.SwiftPackage]
    public let appleSDKs: [Project.Framework]
    public let carthageFrameworks: [Project.Framework]
    public let podsFrameworks: [Project.Framework]
    public let vendorFrameworks: [Project.Framework]

    public init(
        projectName: String,
        nativeTargets: [NativeTarget],
        packageProducts: [Project.SwiftPackage],
        internalPackageProducts: [Project.SwiftPackage],
        appleSDKs: [Project.Framework],
        carthageFrameworks: [Project.Framework],
        podsFrameworks: [Project.Framework],
        vendorFrameworks: [Project.Framework]
    ) {
        self.projectName = projectName
        self.nativeTargets = nativeTargets
        self.packageProducts = packageProducts
        self.localPackageProducts = internalPackageProducts
        self.appleSDKs = appleSDKs
        self.carthageFrameworks = carthageFrameworks
        self.podsFrameworks = podsFrameworks
        self.vendorFrameworks = vendorFrameworks
    }
}
