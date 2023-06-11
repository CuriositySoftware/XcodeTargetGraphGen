import Foundation
import Value

public struct ProjectConverter {
    public init() {}

    public func convert(_ project: Project) -> FormatterRepresentation {
        let (
            packageProducts,
            internalPackageProducts,
            appleSDKs,
            carthageFrameworks,
            podsFrameworks,
            vendorFrameworks
        ) = project.nativeTargets.reduce(
            into: (
                [Project.SwiftPackage](),
                [Project.SwiftPackage](),
                [Project.Framework](),
                [Project.Framework](),
                [Project.Framework](),
                [Project.Framework]()
            )
        ) { accumulators, nativeTarget in
            nativeTarget.packageProductDependencies.forEach { dependency in
                switch dependency.type {
                case .remote:
                    accumulators.0.append(dependency)
                case .local:
                    accumulators.1.append(dependency)
                }
            }

            nativeTarget.otherDependencies.forEach { dependency in
                switch dependency.type {
                case .platformSDK:
                    accumulators.2.append(dependency)

                case .carthage:
                    accumulators.3.append(dependency)

                case .pods:
                    accumulators.4.append(dependency)

                case .vendor:
                    accumulators.5.append(dependency)
                }
            }
        }

        // TODO: internalPackageProducts -> local..
        return sort(
            .init(
                projectName: project.name,
                nativeTargets: project.nativeTargets.map { .init(id: $0.id, name: $0.name) },
                packageProducts: Array(Set(packageProducts)),
                internalPackageProducts: removeDuplicate(internalPackageProducts),
                appleSDKs: Array(Set(appleSDKs)),
                carthageFrameworks: Array(Set(carthageFrameworks)),
                podsFrameworks: Array(Set(podsFrameworks)),
                vendorFrameworks: Array(Set(vendorFrameworks))
            )
        )
    }
}

public extension ProjectConverter {
    func sort(_ dependency: FormatterRepresentation) -> FormatterRepresentation {
        .init(
            projectName: dependency.projectName,
            nativeTargets: dependency.nativeTargets.sorted(
                by: { $0.name < $1.name }
            ),
            packageProducts: dependency.packageProducts.sorted(
                by: { $0.name < $1.name }
            ),
            internalPackageProducts: dependency.localPackageProducts.sorted(
                by: { $0.name < $1.name }
            ),
            appleSDKs: dependency.appleSDKs.sorted(
                by: { $0.name < $1.name }
            ),
            carthageFrameworks: dependency.carthageFrameworks.sorted(
                by: { $0.name < $1.name }
            ),
            podsFrameworks: dependency.podsFrameworks.sorted(
                by: { $0.name < $1.name }
            ),
            vendorFrameworks: dependency.vendorFrameworks.sorted(
                by: { $0.name < $1.name }
            )
        )
    }
}

public extension ProjectConverter {
    /* NOTE:
     SwiftPackage is also assigned an ID in XCSwiftPackageProductDependency
     for the number of pieces targeted.
     However, only remote has a reference to XCRemoteSwiftPackageReference,
     where it can be identified by its ID.
     On the other hand,
     local does not have that reference and cannot be identified and has multiple IDs.
     Therefore, duplication is eliminated by name.
    */
    func removeDuplicate(_ packages: [Project.SwiftPackage]) -> [Project.SwiftPackage] {
        var uniquePackages: [String: Project.SwiftPackage] = [:]

        for package in packages {
            switch package.type {
            case .local:
                // For local packages, we use the package's name as a unique key.
                // If a package with the same name already exists, it will be overwritten.
                uniquePackages[package.name] = package
            case .remote:
                // For remote packages, we still use the id as a unique key.
                uniquePackages[package.id] = package
            }
        }

        // Return the unique packages as an array.
        return Array(uniquePackages.values)
    }
}
