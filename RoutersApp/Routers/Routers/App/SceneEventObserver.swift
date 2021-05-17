//
//  AppEventObserver.swift
//  Routers
//
//  Created by Mateusz Fidos on 17/05/2021.
//

import UIKit


protocol SceneEventObserver: AnyObject {

    // MARK: - Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions,
        window: UIWindow?
    )

    // add more if needed

}
