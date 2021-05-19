//
//  ModuleAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import UIKit


protocol ModuleAssembler {

    typealias Module = UIViewController

    static func assemble(with router: Router) -> Module

}
