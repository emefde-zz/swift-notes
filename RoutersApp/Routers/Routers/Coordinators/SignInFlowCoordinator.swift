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
    Coordinator {

    let parent: FlowCoordinator?


    init(parent: FlowCoordinator) {
        self.parent = parent
    }


    public func start() {

    }

}
