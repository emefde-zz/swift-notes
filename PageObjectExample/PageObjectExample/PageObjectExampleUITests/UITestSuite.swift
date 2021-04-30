//
//  UITestSuite.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import Foundation
import XCTest


open class UITestSuite: XCTestCase {

    public var uiapplication: XCUIApplication!

    override public func setUp() {
        super.setUp()
        continueAfterFailure = false
        uiapplication = XCUIApplication()
        uiapplication.launchArguments = ["testing"]
        uiapplication.launch()
    }

    override public func tearDown() {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .deleteOnSuccess
        add(attachment)
        uiapplication.terminate()
        super.tearDown()
    }
}
