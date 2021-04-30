//
//  MessagePage.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import Foundation
import XCTest


//It's important to use #file and #line arguments in our implementation to capture those values from the call site,
//and equally important to pass our values through to XCTAssertTrue,
//otherwise failures will be captured wherever our function is defined, rather than where we call it.

class MessagePage: PageObject {

    private enum Identifiers {
        static let titleLabel = "titleLabel"
        static let messageTextField = "messageTextField"
        static let sendButton = "sendButton"
        static let alertController = "alertController"
    }

    var uiapplication: XCUIApplication

    init(uiapplication: XCUIApplication) {
        self.uiapplication = uiapplication
    }

    func givenISeeMessageTextField(file: StaticString = #file,
                                   line: UInt = #line
    ) throws -> MessagePage {
        XCTAssertNotNil(
            uiapplication.textFields[TestDependencies.instance.identifiers.messageTextField],
            "Text Field cannot be nil",
            file: file,
            line: line
        )
        return self
    }

    func givenITypeMessage(_ message: String) throws -> MessagePage {
        let textfield = uiapplication.textFields[TestDependencies.instance.identifiers.messageTextField]
        textfield.tap()
        textfield.typeText(message)
        return self
    }

    func thenIShouldSeeSendButtonEnabled(file: StaticString = #file,
                                         line: UInt = #line
    ) throws -> MessagePage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        XCTAssertTrue(
            sendButton.isEnabled,
            "Send button should be enabled",
            file: file,
            line: line
        )
        return self
    }

    func whenIPressSendButton() throws -> MessagePage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        sendButton.tap()
        return self
    }

    @discardableResult
    func thenIShouldSeeSendAlertController(file: StaticString = #file,
                                           line: UInt = #line
    ) throws -> MessagePage {
        let alert = uiapplication.staticTexts["Message cannot be longer than 50 characters"]
        XCTAssertTrue(
            alert.waitForExistence(timeout: 5.0),
            "Alert controller did not appear",
            file: file,
            line: line
        )
        return self
    }

    @discardableResult
    func thenIShouldSeeMessageDetailsPage(file: StaticString = #file,
                                          line: UInt = #line
    ) throws -> MessageDetailsPage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        XCTAssertTrue(
            sendButton.isEnabled,
            "Send button should be enabled",
            file: file,
            line: line
        )
        return MessageDetailsPage(uiapplication: uiapplication)
    }

}
