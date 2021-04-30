//
//  UITestObservation.swift
//  PageObjectExampleUITests
//
//  Created by Mateusz Fidos on 19/04/2021.
//

import Foundation
import XCTest

class MockService {
    func initialize() {}
    func deinitialize() {}
}

//this is just for presentation purpouses
final class TestDependencies {

    struct Identifiers {
        let titleLabel = "titleLabel"
        let messageTextField = "messageTextField"
        let sendButton = "sendButton"
        let alertController = "alertController"
        let messageLabel = "messageLabel"
    }

    static var instance: TestDependencies = TestDependencies()
    private(set) var identifiers: Identifiers = Identifiers()
    private(set) var mockService: MockService = MockService()
    private(set) var hasDependenciesBeenInitialized: Bool = false

    private init() { }

    static func initialize() {
        instance = TestDependencies()
        instance.identifiers = Identifiers()
        instance.mockService.initialize()
        instance.hasDependenciesBeenInitialized = true
    }

    static func deinitialize() {
        instance.mockService.deinitialize()
        instance.hasDependenciesBeenInitialized = false
    }
}


//this class needs to be configured as NSPrincipalClass in Info.plist
@objc(UITestObservation)
class UITestObservation: NSObject, XCTestObservation {

    //add test observers
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }

    //add setup code before every test run
    func testCaseWillStart(_ testCase: XCTestCase) {
        TestDependencies.initialize()
    }

    //add tear down code after each test case run
    func testCaseDidFinish(_ testCase: XCTestCase) {
        TestDependencies.deinitialize()
    }

    //remove observers after test bundle finished running all tests
    func testBundleDidFinish(_ testBundle: Bundle) {
        XCTestObservationCenter.shared.removeTestObserver(self)
    }

}
