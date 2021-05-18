//
//  Router.swift
//  Routers
//
//  Created by Mateusz Fidos on 18/05/2021.
//

import Foundation

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


struct RouteContext {

    let id: String
    let type: RouteDestinationType

    init(
        id: String = UUID().uuidString,
        type: RouteDestinationType = .nextRoute
    ) {
        self.id = id
        self.type = type
    }

}


enum RouteDestinationType {

    case nextRoute
    case previousRoute

}

protocol Route {

    associatedtype T

    var context: RouteContext { get }
    var components: AnyRouteComponent<T>? { get }

}


protocol Router: AnyObject {

    func route<R: Route>(to route: R)

}

struct AnyRoute<T>: Route {

    let context: RouteContext
    let components: AnyRouteComponent<T>?

    init<R: Route>(route: R) {
        self.components = route.components as? AnyRouteComponent<T>
        self.context = route.context
    }

}


var onDismiss: ((AnyRoute<Void>) -> Void)?

func route<R>(to route: R) where R : Route {
    switch route.context.type {
    case .nextRoute:
        show(route: route)
    case .previousRoute:
        onDismiss?(AnyRoute(route: route))
    }
}


private func show<R: Route>(route: R) {

}


private func dismiss<R: Route>(route: R) {
    onDismiss?(AnyRoute(route: route))
}
