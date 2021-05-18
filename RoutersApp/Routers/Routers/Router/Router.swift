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

protocol Route {

    associatedtype T: RouteComponent

    var name: String { get }
    var components: T? { get }

}


protocol Router: AnyObject {

    func route<R: Route>(to route: R)
    func dismiss<R: Route>(with route: R)

}


struct AnyRouteComponent<T>: RouteComponent {

    let id: ID
    let payload: T

}
