//
//  SignInRoute.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import Foundation


struct SignInRoute: Route {

    var name: String { "sign.in.route" }
    var components: AnyRouteComponent<Void>? { nil }

}


struct SignUpRoute: Route {

    var name: String { "sign.up.route" }
    var components: AnyRouteComponent<Void>? { nil }

}


struct AddNameRoute: Route {

    var name: String { "add.name.route" }
    var components: AnyRouteComponent<Void>? { nil }

}

struct AddEmailRoute: Route {

    var name: String { "add.email.route" }
    var components: AnyRouteComponent<String>?

    init(name: String) {
        self.components = AnyRouteComponent(
            id: UUID().uuidString,
            payload: name
        )
    }

}


struct Dismiss<T>: Route {

    var name: String { "dismiss" }
    var components: AnyRouteComponent<T>?

    init(payload: T) {
        self.components = AnyRouteComponent(
            id: UUID().uuidString,
            payload: payload
        )
    }

}
