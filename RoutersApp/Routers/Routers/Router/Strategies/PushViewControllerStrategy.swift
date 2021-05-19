//
//  PushViewControllerStrategy.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import UIKit


final class PushViewControllerStrategy: RouterStrategy {

    let module: ModuleAssembler.Module
    let animated: Bool
    private(set) weak var navigationController: UINavigationController?


    init(
        navigationController: UINavigationController?,
        animated: Bool = true,
        module: @escaping @autoclosure () -> ModuleAssembler.Module
    ) {
        self.navigationController = navigationController
        self.animated = animated
        self.module = module()
    }


    func start() {
        navigationController?.pushViewController(module, animated: animated)
    }

}
