//
//  PopToRootViewControllerStrategy.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import UIKit


final class PopToRootViewControllerStrategy: RouterStrategy {

    let animated: Bool
    private(set) weak var navigationController: UINavigationController?


    init(
        navigationController: UINavigationController?,
        animated: Bool = true
    ) {
        self.navigationController = navigationController
        self.animated = animated
    }


    func start() {
        navigationController?.popToRootViewController(animated: animated)
    }

}
