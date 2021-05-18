//
//  FlowCoordinator.swift
//  Routers
//
//  Created by Mateusz Fidos on 17/05/2021.
//

import Foundation

//holds strong reference to parent
//this way flow coordinator doesn't need to be stored in coordiantor store
//but also there is no need to release it manually when the flow is done

protocol FlowCoordinator {

    var parent: FlowCoordinator? { get }

}
