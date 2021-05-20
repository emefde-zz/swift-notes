//
//  AddEmailFlowCoordinator.swift
//  Routers
//
//  Created by Mateusz Fidos on 20/05/2021.
//

import UIKit


final class AddEmailFlowCoordinator:
    FlowCoordinator,
    Coordinator,
    Router {

    let parent: (FlowCoordinator & Router)
    private weak var navigationController: UINavigationController?


    init(
        parent: (FlowCoordinator & Router),
        navigationController: UINavigationController?
    ) {
        self.parent = parent
        self.navigationController = navigationController
    }


    public func start() {
        PushViewControllerStrategy(
            navigationController: navigationController,
            module: AddEmailAssembler.assemble(with: self)
        ).start()
    }


    func route<R>(to route: R) where R : Route { }

    func dismiss<R>(with route: R) where R : Route {
        parent.dismiss(with: route)
    }

}
