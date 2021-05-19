//
//  SignInAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import Foundation


enum SignInAssembler: ModuleAssembler {

    static func assemble(with router: Router) -> Module {
        SignInViewController(
            interactor: SignInInteractor(
                router: router
            )
        )
    }

}
