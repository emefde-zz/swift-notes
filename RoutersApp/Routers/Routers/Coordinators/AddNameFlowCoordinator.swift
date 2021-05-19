//
//  AddNameFlowCoordinator.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import UIKit


final class AddNameFlowCoordinator:
    FlowCoordinator,
    Coordinator,
    Router {

    let parent: FlowCoordinator?
    private weak var navigationController: UINavigationController?


    init(
        parent: FlowCoordinator,
        navigationController: UINavigationController?
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }


    public func start() {
        PushViewControllerStrategy(
            navigationController: navigationController,
            module: AddNameAssembler.assemble(with: self)
        ).start()
    }


    func route<R>(to route: R) where R : Route {
        switch ValidRoutes.init(rawValue: route.name) {
        case .email:
            break
        default:
            assertionFailure(Constants.Assertion.invalidRouteAssertion)
        }
    }


    func dismiss<R>(with route: R) where R : Route { }

}


private extension AddNameFlowCoordinator {

    enum ValidRoutes: String {

        case email = "add.email.route"

    }

}
