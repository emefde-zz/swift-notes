import Foundation

//test example with PageObject pattern


class ExampleTestCase: UITestSuite {

    func testsUserAuthenticatedAndAppLaunches() throws {
        try LaunchPage(testApplication: app)
                .givenAuthenticatedUser()
                .givenSuccessfulConfigRequest()
                .thenTheAppLaunches()
                .thenISeeHomePage()
    }


    func testsUserUnAuthenticatedAndAppLaunchesWithOnboarding() throws {
        try LaunchPage(testApplication: app)
                .givenUnAuthenticatedUser()
                .givenSuccessfulConfigRequest()
                .thenTheAppLaunches()
                .thenISeeOnboardingPage()
    }


    func testsOnboardingOpensSignIn() throws {
        let onboardingPage = try LaunchPage(testApplication: app)
            .givenUnAuthenticatedUser()
            .givenSuccessfulConfigRequest()
            .thenTheAppLaunches()
            .thenISeeOnboardingPage()

        onboardingPage
            .whenSignInButtonTapped()
            //.thenISeeSignInPage()
            //and so on...
    }

}
