//
//  SignInFlowCoordinator.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import Foundation
import UIKit


final class SignInFlowCoordinator:
    FlowCoordinator,
    Coordinator,
    Router {

    let parent: (FlowCoordinator & Router)
    private weak var navigationController: UINavigationController?


    init(
        parent: (FlowCoordinator & Router),
        navigationController: UINavigationController
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }


    public func start() {
        PushViewControllerStrategy(
            navigationController: navigationController,
            module: SignInAssembler.assemble(with: self)
        ).start()
    }


    func route<R>(to route: R) where R : Route {
        switch ValidRoutes.init(rawValue: route.name) {
        case .name:
            AddNameFlowCoordinator(
                parent: parent,
                navigationController: navigationController
            ).start()
        default:
            assertionFailure(Constants.Assertion.invalidRouteAssertion)
        }
    }


    func dismiss<R>(with route: R) where R : Route { }

}


private extension SignInFlowCoordinator {

    enum ValidRoutes: String {

        case name = "add.name.route"

    }

}
