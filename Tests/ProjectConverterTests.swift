import XCTest
@testable import Mermaid
@testable import Value
@testable import Converter

final class ProjectConverterTests: XCTestCase {

    func testReduce() {
        let packageProductA = Project.SwiftPackage(
            id: "A", name: "A", packageName: "A", type: .remote(urlString: "")
        )
        let packageProductB1 = Project.SwiftPackage(
            id: "B1", name: "B1", packageName: "B", type: .remote(urlString: "")
        )
        let packageProductB2 = Project.SwiftPackage(
            id: "B2", name: "B2", packageName: "B", type: .remote(urlString: "")
        )

        let internalPackageProduct1 = Project.SwiftPackage(
            id: "P1", name: "InternalProduct1", packageName: nil, type: .local
        )
        let internalPackageProduct2 = Project.SwiftPackage(
            id: "P2", name: "InternalProduct2", packageName: nil, type: .local
        )

        let appleSDKあ = Project.Framework(
            id: "AppleSDKあ",
            name: "AppleSDKあ",
            type: .platformSDK
        )
        let appleSDKい = Project.Framework(
            id: "AppleSDKい",
            name: "AppleSDKい",
            type: .platformSDK
        )

        let carthageFramework1 = Project.Framework(
            id: "CarthageFramework1",
            name: "CarthageFramework1",
            type: .carthage
        )
        let carthageFramework0 = Project.Framework(
            id: "CarthageFramework0",
            name: "CarthageFramework0",
            type: .carthage
        )

        let podsFramework = Project.Framework(
            id: "PodsFramework",
            name: "PodsFramework",
            type: .pods
        )
        let vendorFramework = Project.Framework(
            id: "VendorFramework",
            name: "VendorFramework",
            type: .vendor
        )

        let project = Project(
            name: "ProjectName",
            nativeTargets: [
                .init(
                    id: "NativeTargetID",
                    name: "NativeTarget",
                    targetDependencies: [
                        Project.Target.init(id: "A", name: "Target")
                    ],
                    packageProductDependencies: [
                        packageProductA,
                        packageProductB1,
                        packageProductB2,
                        internalPackageProduct1,
                        internalPackageProduct2
                    ],
                    otherDependencies: [
                        appleSDKあ,
                        appleSDKい,
                        carthageFramework1,
                        carthageFramework0,
                        podsFramework,
                        vendorFramework
                    ]
                )
            ]
        )

        let subject = ProjectConverter().convert(project)

        XCTAssertEqual(
            subject.nativeTargets,
            [
                .init(id: "NativeTargetID", name: "NativeTarget")
            ]
        )

        XCTAssertEqual(
            subject.packageProducts,
            [packageProductA, packageProductB1, packageProductB2]
        )

        XCTAssertEqual(
            subject.appleSDKs,
            [appleSDKあ, appleSDKい]
        )

        XCTAssertEqual(
            subject.carthageFrameworks,
            [carthageFramework0, carthageFramework1]
        )

        XCTAssertEqual(
            subject.podsFrameworks,
            [podsFramework]
        )

        XCTAssertEqual(
            subject.vendorFrameworks,
            [vendorFramework]
        )
    }
}
