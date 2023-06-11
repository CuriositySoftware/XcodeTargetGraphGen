import XCTest
@testable import Mermaid
@testable import Value

final class MermaidFormatterTests: XCTestCase {

    func testProject() throws {
        let project = Project(
            name: "",
            nativeTargets: [
                .init(
                    id: "App",
                    name: "App",
                    targetDependencies: [.init(id: "A", name: "Core")],
                    packageProductDependencies: [],
                    otherDependencies: []
                ),
                .init(
                    id: "ShareExtension",
                    name: "ShareExtension",
                    targetDependencies: [.init(id: "B", name: "Core")],
                    packageProductDependencies: [],
                    otherDependencies: []
                )
            ]
        )

        XCTAssertEqual(
            MermaidFormatter().format(
                with: project,
                mermaidTheme: "dark",
                syntaxType: SyntaxType.flowchart(.topDown),
                appleSDKOutput: false
            ),
            """
            ```mermaid
            %%{init: {'theme':'dark'}}%%
            flowchart TD

            subgraph Native Target
            App["App"]
            ShareExtension["ShareExtension"]
            end
            App --> Core
            ShareExtension --> Core
            ```

            """
        )
    }

    func testProjectIsEmpty() throws {
        XCTContext.runActivity(named: "Select Syntax Type") { _ in
            XCTContext.runActivity(named: "Flowchart") { _ in
                XCTContext.runActivity(named: "TD") { _ in
                    XCTAssertEqual(
                        MermaidFormatter().format(
                            with: Project(name: ""),
                            mermaidTheme: "dark",
                            syntaxType: SyntaxType.flowchart(.topDown),
                            appleSDKOutput: false
                        ),
                        """
                        ```mermaid
                        %%{init: {'theme':'dark'}}%%
                        flowchart TD

                        ```

                        """
                    )
                }

                XCTContext.runActivity(named: "BU") { _ in
                    XCTAssertEqual(
                        MermaidFormatter().format(
                            with: Project(name: ""),
                            mermaidTheme: "dark",
                            syntaxType: SyntaxType.flowchart(.bottomUp),
                            appleSDKOutput: false
                        ),
                        """
                        ```mermaid
                        %%{init: {'theme':'dark'}}%%
                        flowchart BU

                        ```

                        """
                    )
                }
            }

            XCTContext.runActivity(named: "Graph") { _ in
                XCTContext.runActivity(named: "TD") { _ in
                    XCTAssertEqual(
                        MermaidFormatter().format(
                            with: Project(name: ""),
                            mermaidTheme: "dark",
                            syntaxType: SyntaxType.graph(.topDown),
                            appleSDKOutput: false
                        ),
                        """
                        ```mermaid
                        %%{init: {'theme':'dark'}}%%
                        graph TD

                        ```

                        """
                    )
                }

                XCTContext.runActivity(named: "BU") { _ in
                    XCTAssertEqual(
                        MermaidFormatter().format(
                            with: Project(name: ""),
                            mermaidTheme: "dark",
                            syntaxType: SyntaxType.graph(.bottomUp),
                            appleSDKOutput: false
                        ),
                        """
                        ```mermaid
                        %%{init: {'theme':'dark'}}%%
                        graph BU

                        ```

                        """
                    )
                }
            }
        }

        XCTContext.runActivity(named: "Toggle hide and show Apple SDK") { _ in
            XCTContext.runActivity(named: "Hide") { _ in
                XCTAssertEqual(
                    MermaidFormatter().format(
                        with: Project(name: ""),
                        mermaidTheme: "dark",
                        syntaxType: SyntaxType.flowchart(.topDown),
                        appleSDKOutput: false
                    ),
                    """
                    ```mermaid
                    %%{init: {'theme':'dark'}}%%
                    flowchart TD

                    ```

                    """
                )
            }

            XCTContext.runActivity(named: "Show") { _ in
                XCTAssertEqual(
                    MermaidFormatter().format(
                        with: Project(name: ""),
                        mermaidTheme: "dark",
                        syntaxType: SyntaxType.flowchart(.topDown),
                        appleSDKOutput: true
                    ),
                    """
                    ```mermaid
                    %%{init: {'theme':'dark'}}%%
                    flowchart TD

                    ```

                    """
                )
            }
        }
    }
}
