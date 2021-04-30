//
//  MessageDetailsPage.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import Foundation
import XCTest

class MessageDetailsPage: PageObject {

    enum Identifiers {
        static let messageLabel = "messageLabel"
    }

    var uiapplication: XCUIApplication

    init(uiapplication: XCUIApplication) {
        self.uiapplication = uiapplication
    }

    @discardableResult
    func thenICanVerifyMessage(
        _ message: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> MessageDetailsPage {
        let message = uiapplication.staticTexts[message]
        XCTAssertTrue(
            message.waitForExistence(timeout: 5.0),
            "Message did not appear",
            file: file,
            line: line
        )
        return self
    }

}
