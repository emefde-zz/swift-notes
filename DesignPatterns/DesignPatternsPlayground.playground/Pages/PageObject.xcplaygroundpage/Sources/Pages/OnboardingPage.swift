import Foundation
import XCTest

public class OnboardingPage: PageObject {

    public var testApplication: XCUIApplication

    public init(testApplication: XCUIApplication) {
        self.testApplication = testApplication
    }


    public func whenSignInButtonTapped() -> OnboardingPage {
        let signInButton = testApplication.buttons["signInButton"]
        signInButton.tap()
        return self
    }

    public func whenSignUpButtonTapped() -> OnboardingPage {
        let signUpButton = testApplication.buttons["signUpButton"]
        signUpButton.tap()
        return self
    }

    //some other actions...

//    func thenISeeRegistrationPage() -> RegistrationPage {
//
//    }
}
