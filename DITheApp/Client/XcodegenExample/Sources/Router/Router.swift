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

    typealias Key = String
    typealias ID = String

    var id: ID { get }
    var payload: [Key: Any] { get }

}

protocol Route {

    init?(components: RouteComponent)

    var components: RouteComponent? { get }

}


extension Route {

    init(components: RouteComponent) throws {
        guard let route = Self(components: components) else {
            throw RouteError.routeNotFound
        }

        self = route
    }

}


protocol Router: AnyObject {

    func route(to: Route)

}
