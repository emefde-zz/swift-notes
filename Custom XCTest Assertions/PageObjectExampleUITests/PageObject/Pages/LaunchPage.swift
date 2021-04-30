//
//  LaunchPage.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import Foundation
import XCTest

class LaunchPage: PageObject {

    var uiapplication: XCUIApplication

    init(uiapplication: XCUIApplication) {
        self.uiapplication = uiapplication
    }

    func givenISeeMessagePage(
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> MessagePage {
        XCTAssertTrue(
            TestDependencies.instance.hasDependenciesBeenInitialized,
            "TestDependencies were not initialized",
            file: file,
            line: line
        )
        let title = uiapplication.staticTexts[TestDependencies.instance.identifiers.titleLabel]
        XCTAssertEqual(
            title.label, "Write something here",
            "Label string was incorrect",
            file: file,
            line: line
        )
        XCTAssertNotNil(
            title,
            "Message title label cannot be nil",
            file: file,
            line: line
        )
        return MessagePage(uiapplication: uiapplication)
    }


    //Second version without custom assertions passed to XCAssert
    func givenISeeMessagePageNoCustomAssertion() throws -> MessagePage {
        XCTAssertTrue(
            TestDependencies.instance.hasDependenciesBeenInitialized,
            "TestDependencies were not initialized"
        )
        let title = uiapplication.staticTexts[TestDependencies.instance.identifiers.titleLabel]
        XCTAssertEqual(
            title.label, "Write something here",
            "Label string was incorrect"
        )
        XCTAssertNotNil(
            title,
            "Message title label cannot be nil"
        )
        return MessagePage(uiapplication: uiapplication)
    }
}
