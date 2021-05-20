//
//  AddNameInteractor.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import Foundation


final class AddNameInteractor {

    let router: Router


    init(router: Router) {
        self.router = router
    }


    func submit(name: String?) {
        guard let name = name else { return }
        router.route(to: AddEmailRoute(name: name))
    }

}
