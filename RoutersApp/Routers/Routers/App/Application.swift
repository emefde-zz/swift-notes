//
//  Application.swift
//  Routers
//
//  Created by Mateusz Fidos on 17/05/2021.
//

import UIKit


class Application: SceneEventObserver {

    private let appFlowCoordinator: AppFlowCoordinator

    init(appFlowCoordinator: AppFlowCoordinator) {
        self.appFlowCoordinator = appFlowCoordinator
    }


    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions,
        window: UIWindow?
    ) {
        appFlowCoordinator.assign(window: window)
        appFlowCoordinator.start()
    }

}
