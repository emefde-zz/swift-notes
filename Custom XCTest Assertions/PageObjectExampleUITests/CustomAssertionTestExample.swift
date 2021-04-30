//
//  PageObjectExampleUITests.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import XCTest

//After you run the tests you'll notice how tests that fail using custom assertions show their failures exactly at callsite
//but those without custom assetions are captured in defining class
//With custom assertions it's much easier to pin point exact place of failing scenario.

class CustomAssertionTestExample: UITestSuite {

    private enum Constants {
        static let validMessage: String = "This is test message"
        static let invalidMessage: String = """
        This is an invalid test message This is an invalid test message This is an invalid test message This is an invalid test message
        This is an invalid test messageThis is an invalid test message This is an invalid test messageThis is an invalid test message
        This is an invalid test messageThis is an invalid test message This is an invalid test messageThis is an invalid test message
        """
    }


    func test_CustomAssertionVerifyMessageSuccessScenario() throws {
        try LaunchPage(uiapplication: uiapplication)
            .givenISeeMessagePage()
            .givenISeeMessageTextField()
            .givenITypeMessage(Constants.validMessage)
            .thenIShouldSeeSendButtonEnabled()
            .whenIPressSendButton()
            .thenIShouldSeeMessageDetailsPage()
            .thenICanVerifyMessage(Constants.validMessage)
    }


    func test_CustomAssertionFailScenario() throws {
        TestDependencies.instance.hasDependenciesBeenInitialized = false
        try LaunchPage(uiapplication: uiapplication)
            .givenISeeMessagePage()
            .givenISeeMessageTextField()
            .givenITypeMessage(Constants.invalidMessage)
            .thenIShouldSeeSendButtonEnabled()
            .whenIPressSendButton()
            .thenIShouldSeeSendAlertController()
    }


    func test_NoCustomAssertionFailScenario() throws {
        TestDependencies.instance.hasDependenciesBeenInitialized = false
        try LaunchPage(uiapplication: uiapplication)
            .givenISeeMessagePageNoCustomAssertion()
            .givenISeeMessageTextField()
            .givenITypeMessage(Constants.invalidMessage)
            .thenIShouldSeeSendButtonEnabled()
            .whenIPressSendButton()
            .thenIShouldSeeSendAlertController()
    }

}
