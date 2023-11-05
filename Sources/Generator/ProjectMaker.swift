import Foundation
import XcodeProj
import PathKit
import Value
import Client

struct ProjectMaker {
    let fileListReaderClient: FileListReaderClient

    init(fileListReaderClient: FileListReaderClient = .live) {
        self.fileListReaderClient = fileListReaderClient
    }

    func makeProject(from xcodeProject: XcodeProj) -> Project {
        .init(
            name: xcodeProject.pbxproj.rootObject?.name ?? "",
            nativeTargets: xcodeProject.pbxproj.nativeTargets.compactMap {
                guard let productName = $0.productName else {
                    return nil
                }
                return .init(
                    id: $0.uuid,
                    name: productName,
                    targetDependencies: Array(
                        Set(
                            $0.dependencies.compactMap {
                                guard let target = $0.target else {
                                    return nil
                                }

                                return .init(
                                    id: target.uuid,
                                    name: target.name
                                )
                            }
                        )
                    ),
                    packageProductDependencies: Array(
                        Set(
                            $0.packageProductDependencies.map {
                                if let package = $0.package, let urlString = package.repositoryURL {
                                    return .init(
                                        id: $0.uuid,
                                        name: $0.productName,
                                        packageName: package.name,
                                        type: .remote(
                                            urlString: urlString
                                        )
                                    )
                                } else {
                                    return .init(
                                        id: $0.uuid,
                                        name: $0.productName,
                                        packageName: nil,
                                        type: .local
                                    )
                                }
                            }
                        )
                    ),
                    otherDependencies: Array(Set(map($0.buildPhases)))
                )
            }
        )
    }
}

private extension ProjectMaker {
    func map(_ buildPhases: [PBXBuildPhase]) -> [Project.Framework] {
        let podsArray = pods(buildPhases)

        let others: [Project.Framework] = buildPhases.first {
            $0.buildPhase == .frameworks && $0.files != nil && !$0.files!.isEmpty
        }?.files?.compactMap { file in
            guard let fileElement = file.file,
                let fileName = fileElement.name,
                let path = fileElement.path,
                file.product == nil
            else {
                // Swift Package
                return nil
            }

            if isAppleSDK(fileElement, path) {
                return .init(
                    id: fileName,
                    name: fileName,
                    type: .platformSDK
                )
            } else if path.hasPrefix("Carthage/") {
                return .init(
                    id: fileName,
                    name: fileName,
                    type: .carthage
                )
            } else if fileElement.sourceTree != .sdkRoot {
                return .init(
                    id: fileName,
                    name: fileName,
                    type: .vendor
                )
            }

            return nil
        } ?? []

        return podsArray + others
    }

    func pods(_ buildPhases: [PBXBuildPhase]) -> [Project.Framework] {
        let embedPodsFrameworksPhase: PBXShellScriptBuildPhase? = buildPhases.first {
            if let phase = $0 as? PBXShellScriptBuildPhase,
               let shellScript = phase.shellScript,
               shellScript.contains("PODS_ROOT"),
               !shellScript.contains("Manifest.lock")
            {
                return true
            }
            return false
        } as? PBXShellScriptBuildPhase

        guard let embedPodsFrameworksPhase = embedPodsFrameworksPhase else {
            return []
        }

        return embedPodsFrameworksPhase.outputPaths.map { string in
            .init(
                id: Path(string).lastComponent,
                name: Path(string).lastComponent,
                type: .pods
            )
        }
    }
}

private extension ProjectMaker {
    func isAppleSDK(_ file: PBXFileElement, _ path: String) -> Bool {
        (
            file.sourceTree == .sdkRoot && path.hasPrefix("System/Library/")
        ) || (
            file.sourceTree == .developerDir && path.hasPrefix("Platforms/")
        )
    }
}
