//
//  OnboardingInteractor.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import Foundation


final class OnboardingInteractor {

    let router: Router


    init(router: Router) {
        self.router = router
    }

    
    func signIn() {
        router.route(to: SignInRoute())
    }

    func signUp() {
        router.route(to: SignUpRoute())
    }


}
