//
//  MessagePage.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import Foundation
import XCTest

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

    func givenISeeMessageTextField() throws -> MessagePage {
        XCTAssertNotNil(uiapplication.textFields[TestDependencies.instance.identifiers.messageTextField])
        return self
    }

    func givenITypeMessage(_ message: String) throws -> MessagePage {
        let textfield = uiapplication.textFields[TestDependencies.instance.identifiers.messageTextField]
        textfield.tap()
        textfield.typeText(message)
        return self
    }

    func thenIShouldSeeSendButtonEnabled() throws -> MessagePage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        XCTAssertTrue(sendButton.isEnabled)
        return self
    }

    func whenIPressSendButton() throws -> MessagePage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        sendButton.tap()
        return self
    }

    @discardableResult
    func thenIShouldSeeSendAlertController() throws -> MessagePage {
        let alert = uiapplication.staticTexts["Message cannot be longer than 50 characters"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5.0))
        return self
    }

    @discardableResult
    func thenIShouldSeeMessageDetailsPage() throws -> MessageDetailsPage {
        let sendButton = uiapplication.buttons[TestDependencies.instance.identifiers.sendButton]
        XCTAssertTrue(sendButton.isEnabled)
        return MessageDetailsPage(uiapplication: uiapplication)
    }

}
