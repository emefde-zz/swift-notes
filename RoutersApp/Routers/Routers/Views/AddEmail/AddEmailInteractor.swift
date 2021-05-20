//
//  AddEmailInteractor.swift
//  Routers
//
//  Created by Mateusz Fidos on 20/05/2021.
//

import Foundation


final class AddEmailInteractor {

    let router: Router
    let userName: String


    init(router: Router, userName: String) {
        self.router = router
        self.userName = userName
    }


    func submit(email: String?) {
        guard let email = email else { return }
        router.dismiss(
            with: Dismiss(
                payload: User(
                    name: userName,
                    email: email
                )
            )
        )
    }

}

