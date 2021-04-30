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

    func givenISeeMessagePage() throws -> MessagePage {
        let title = uiapplication.staticTexts[MessagePage.Identifiers.titleLabel]
        XCTAssertEqual(title.label, "Write something here")
        XCTAssertNotNil(title, "Message title label present")
        return MessagePage(uiapplication: uiapplication)
    }
}
