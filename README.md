# XcodeTargetGraphGen

![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

XcodeTargetGraphGen is a Swift command line tool that analyzes .xcodeproj files to generate a visualization of module-level internal dependencies using Mermaid diagram syntax. It supports multiple package managers, providing a clear representation of the structure and dependencies in Xcode projects across various environments. This facilitates a deeper understanding of the organization of modules in complex projects.

The supported package managers are as follows:

- Swift Package Manager
- Carthage
- CocoaPods (only supports the old format that does not use [.xcfilelist](https://blog.cocoapods.org/CocoaPods-1.7.0-beta/))
