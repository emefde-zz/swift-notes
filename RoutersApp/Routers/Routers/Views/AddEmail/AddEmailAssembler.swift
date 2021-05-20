//
//  AddEmailAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 20/05/2021.
//

import Foundation


enum AddEmailAssembler: ModuleAssembler {

    static func assemble(with router: Router) -> Module {
        AddEmailViewController(
            interactor: AddEmailInteractor(
                router: router,
                userName: "asd"
            )
        )
    }

}
