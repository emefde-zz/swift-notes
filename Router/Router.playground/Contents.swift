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


struct User {

    let name: String
    let email: String

}

protocol RouterStrategy {



}


protocol Coordinator {
    func start()
}


import UIKit


class PresentationContext {

    private(set) weak var presentingController: UIViewController?


    public init(presentingController: UIViewController?) {
        self.presentingController = presentingController
    }

}


class NavigationPresentationContext: PresentationContext {

    private(set) weak var presentingNavigationController: UINavigationController?


    public init(presentingController: UINavigationController?) {
        self.presentingNavigationController = presentingController
        super.init(presentingController: presentingController)
    }

}


final class SignInCoordinator: Coordinator, Router {

    var onDismiss: ((Route) -> Void)?

    func route<R>(to route: R) where R : Route {
        switch route.context.type {
        case .nextRoute:
            show(route: route)
        case .previousRoute:
            onDismiss?()
        }
    }


    private func show<R: Route>(route: R) {

    }


    private func dismiss<R: Route>(route: R) {
        onDismiss?()
    }


    func start() {
        let signInViewController = SignInViewController()
        let singInInteractor = SignInInteractor(router: self)
        singInInteractor.dismiss()
    }

}


struct SingInRoute: Route {

    var context: RouteContext { RouteContext(id: "sign.in", type: .nextRoute) }
    var components: AnyRouteComponent<Void>? { nil }

}

struct DismissSingInRoute: Route {

    var context: RouteContext { RouteContext(id: "dismiss.sign.in", type: .previousRoute) }
    var components: AnyRouteComponent<Void>? { nil }

}

struct SignInInteractor {

    let router: Router


    func dismiss() {
        router.route(to: DismissSingInRoute())
    }

}

final class SignInViewController: UIViewController {

}


final class BaseCoordinator: Coordinator, Router {

    typealias FlowCoordinator = Coordinator & Router

    private var store: [String: FlowCoordinator] = [:]

    private enum ValidRoutes: String {
        case signIn = "sign.in"
    }


    var onDismiss: (() -> Void)?

    func route<R>(to route: R) where R : Route {
        switch route.context.type {
        case .nextRoute:
            show(route: route)
        case .previousRoute:
            dismiss(route: route)
        }
    }


    func start() {
        let baseViewController = BaseViewController()
        let baseInteractor = BaseInteractor(router: self)
        baseInteractor.showSignIn()
    }


    private func resolveCoordinator<R: Route>(_ route: R) -> FlowCoordinator? {
        store[route.context.id]
    }


    private func register<R: Route>(coordinator: FlowCoordinator, for route: R) {
        store[route.context.id] = coordinator
    }


    private func show<R: Route>(route: R) {
        print(route)
        if let coordinator = resolveCoordinator(route) {
            coordinator.start()
            return
        }

        switch ValidRoutes(rawValue: route.context.id) {
        case .signIn:
            let coordinator = SignInCoordinator()
            coordinator.onDismiss = {
                print("did dismiss route \(route)")
            }
            register(coordinator: coordinator, for: route)
            coordinator.start()
        default:
            break
        }
    }


    private func dismiss<R: Route>(route: R) {
        print(route)
        if let coordinator = resolveCoordinator(route) {
            coordinator
        }
    }

}


struct BaseInteractor {

    let router: Router


    func showSignIn() {
        router.route(to: SingInRoute())
    }

}

final class BaseViewController: UIViewController {

}


let baseCoordinator = BaseCoordinator()
baseCoordinator.start()



