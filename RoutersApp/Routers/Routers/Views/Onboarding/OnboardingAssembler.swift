//
//  OnboardingAssembler.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import UIKit


enum OnboardingAssembler {

    static func assemble() -> UIViewController {
        OnboardingViewController(interactor: OnboardingInteractor())
    }

}
