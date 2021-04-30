import Foundation
import XCTest

public class LaunchPage: PageObject {

    public var testApplication: XCUIApplication
    let application: Application = Application()

    private let window: UIWindow = UIWindow()

    public init(testApplication: XCUIApplication) {
        self.testApplication = testApplication
    }


    public func givenAuthenticatedUser() -> LaunchPage {
        //some code to fetch user from backend thats authenticated
        return self
    }

    public func givenUnAuthenticatedUser() -> LaunchPage {
        //some code to fetch user from backend thats authenticated
        return self
    }

    public func givenSuccessfulConfigRequest() -> LaunchPage {
        //some code to fetch config from backend
        return self
    }

    public func givenUnSuccessfulConfigRequest() -> LaunchPage {
        //some code to fetch config from backend that fails
        return self
    }

    public func thenTheAppLaunches() -> LaunchPage {
        application.application(UIApplication.shared,
            didFinishLaunchingWithOptions: nil,
            window: window
        )
        return self
    }
}


public extension LaunchPage {

    //just for better tests visualization will make this method throw
    //home page may/may not be there

    func thenISeeHomePage(
        _ wasHomePageEmbedded: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> HomePage {
        //some nifty check to see if HomeViewController is on top
        //requires async work

        //just for presentation purposes
        XCTAssertTrue(wasHomePageEmbedded, "Expected Home Page to be on top",
                      file: file,
                      line: line)

        return HomePage(testApplication: testApplication)
    }

}


public extension LaunchPage {

    //just for better tests visualization will make this method throw
    //onboarding page may/may not be there

    func thenISeeOnboardingPage(
        _ wasOnboardingPushed: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> OnboardingPage {
        //some nifty check to see if HomeViewController is on top
        //requires async work

        //just for presentation purposes
        XCTAssertTrue(wasOnboardingPushed, "Expected Onboarding Page to be on top",
                      file: file,
                      line: line)

        return OnboardingPage(testApplication: testApplication)
    }

}
