//
//  AddNameAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import Foundation


enum AddNameAssembler: ModuleAssembler {

    static func assemble(with router: Router) -> Module {
        AddNameViewController(
            interactor: AddNameInteractor(
                router: router
            )
        )
    }

}
