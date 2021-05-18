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

    var parent: FlowCoordinator? { nil }

    private var window: UIWindow?
    private lazy var rootViewController = OnboardingAssembler.assemble(with: self)
    private(set) weak var presentedViewController: UIViewController?
    private lazy var presentingNavigationController: UINavigationController = UINavigationController()


    public func assign(window: UIWindow?) {
        self.window = window
    }


    public func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        presentedViewController = rootViewController
    }

    func route<R>(to route: R) where R : Route { print(route.name) }
    func dismiss<R>(with route: R) where R : Route { print(route.name) }

}
