//
//  PageObjectExampleUITests.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import XCTest

class PageObjectExampleUITests: UITestSuite {

    private enum Constants {
        static let validMessage: String = "This is test message"
        static let invalidMessage: String = """
        This is an invalid test message This is an invalid test message This is an invalid test message This is an invalid test message
        This is an invalid test messageThis is an invalid test message This is an invalid test messageThis is an invalid test message
        This is an invalid test messageThis is an invalid test message This is an invalid test messageThis is an invalid test message
        """
    }


    func test_PageObjectVerifyMessage() throws {
        try LaunchPage(uiapplication: uiapplication)
            .givenISeeMessagePage()
            .givenISeeMessageTextField()
            .givenITypeMessage(Constants.validMessage)
            .thenIShouldSeeSendButtonEnabled()
            .whenIPressSendButton()
            .thenIShouldSeeMessageDetailsPage()
            .thenICanVerifyMessage(Constants.validMessage)
    }


    func test_PageObjectError() throws {
        try LaunchPage(uiapplication: uiapplication)
            .givenISeeMessagePage()
            .givenISeeMessageTextField()
            .givenITypeMessage(Constants.invalidMessage)
            .thenIShouldSeeSendButtonEnabled()
            .whenIPressSendButton()
            .thenIShouldSeeSendAlertController()
    }

}
