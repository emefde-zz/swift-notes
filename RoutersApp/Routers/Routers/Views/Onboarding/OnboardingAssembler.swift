//
//  OnboardingAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import UIKit


enum OnboardingAssembler: ModuleAssembler {

    static func assemble(with router: Router) -> UIViewController {
        OnboardingViewController(
            interactor: OnboardingInteractor(
                router: router
            )
        )
    }

}
