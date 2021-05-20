//
//  AppCoordinator.swift
//  Routers
//
//  Created by Mateusz Fidos on 17/05/2021.
//

import Foundation
import UIKit


final class AppFlowCoordinator:
    FlowCoordinator,
    Coordinator,
    Router {

    var parent: (FlowCoordinator & Router) { self }

    private var window: UIWindow?
    private lazy var rootViewController = OnboardingAssembler.assemble(with: self)
    private(set) weak var presentedViewController: UIViewController?
    private lazy var presentingNavigationController: UINavigationController = {
        UINavigationController(rootViewController: rootViewController)
    }()


    public func assign(window: UIWindow?) {
        self.window = window
    }


    public func start() {
        window?.rootViewController = presentingNavigationController
        window?.makeKeyAndVisible()
        presentedViewController = rootViewController
    }


    func route<R>(to route: R) where R : Route {
        switch ValidRoutes.init(rawValue: route.name) {
        case .signIn:
            SignInFlowCoordinator(
                parent: self,
                navigationController: presentingNavigationController
            ).start()
        case .signUp:
            break
        default:
            assertionFailure(Constants.Assertion.invalidRouteAssertion)
        }
    }


    func dismiss<R>(with route: R) where R : Route {
        PopToRootViewControllerStrategy(
            navigationController: presentingNavigationController
        ).start()
    }

}


private extension AppFlowCoordinator {

    enum ValidRoutes: String {

        case signIn = "sign.in.route"
        case signUp = "sign.up.route"

    }

}
