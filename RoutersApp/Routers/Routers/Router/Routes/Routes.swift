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


struct Dismiss<T>: Route {

    var name: String { "dismiss" }
    var components: AnyRouteComponent<T>?

}
