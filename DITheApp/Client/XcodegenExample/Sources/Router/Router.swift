//
//  Router.swift
//  Client
//
//  Created by Mateusz Fidos on 15/05/2021.
//  Copyright © 2021 mfd corp. All rights reserved.
//

import Foundation

enum Strings {

    enum Errors {

        static let routeNotFoundError = "route not found"

    }
}


enum RouteError: Error, CustomDebugStringConvertible {

    case routeNotFound

    var debugDescription: String {
        switch self {
        case .routeNotFound:
            return Strings.Errors.routeNotFoundError
        }
    }
}

protocol RouteComponent {

    associatedtype Payload
    typealias ID = String

    var id: ID { get }
    var payload: Payload { get }

}


struct AnyRouteComponent<T>: RouteComponent {

    let id: ID
    let payload: T

}

protocol Route {

    associatedtype T

    init(components: AnyRouteComponent<T>)

    var components: AnyRouteComponent<T> { get }

}


protocol Router: AnyObject {

    func route<R: Route>(to route: R)

}


final class LoginRouter: Router {

    func route<R>(to route: R) where R : Route {

    }

}

struct User {

    let name: String
    let email: String

}


struct AnyRoute<T>: Route {

    let components: AnyRouteComponent<T>

    init(components: AnyRouteComponent<T>) {
        self.components = components
    }
}


let loginRoute = AnyRoute<User>(components: AnyRouteComponent<User>(id: "login.route", payload: <#T##User#>)
