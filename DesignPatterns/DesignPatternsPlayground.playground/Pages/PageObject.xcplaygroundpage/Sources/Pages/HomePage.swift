import Foundation
import XCTest

public class HomePage: PageObject {

    public var testApplication: XCUIApplication

    public init(testApplication: XCUIApplication) {
        self.testApplication = testApplication
    }

}
