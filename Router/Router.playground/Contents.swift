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

    var onDismiss: (() -> Void)?

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


protocol CoordinatorStore {

    typealias Key = String

    var store: [Key: FlowCoordinator] { get }

    func resolveCoordinator<R: Route>(_ route: R) -> FlowCoordinator?
    func register<R: Route>(coordinator: FlowCoordinator, for route: R)
    func clear<R: Route>(route: R)

}

final class ConcreteCoordinatorStore: CoordinatorStore {

    private(set) var store: [String: FlowCoordinator] = [:]

    func resolveCoordinator<R: Route>(_ route: R) -> FlowCoordinator? {
        store[route.context.id]
    }


    func register<R: Route>(coordinator: FlowCoordinator, for route: R) {
        store[route.context.id] = coordinator
    }


    func clear<R: Route>(route: R) {
        store[route.context.id] = nil
    }

}

typealias FlowCoordinator = Coordinator & Router
final class BaseCoordinator: Coordinator, Router {

    private let store: ConcreteCoordinatorStore = ConcreteCoordinatorStore()

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
        store.resolveCoordinator(route)
    }


    private func register<R: Route>(coordinator: FlowCoordinator, for route: R) {
        store.register(coordinator: coordinator, for: route)
        print(store.store)
    }


    private func clear<R: Route>(route: R) {
        store.clear(route: route)
        print(store.store.contains(where: { (key, value) in key == "sign.in" }))
        print(store.store)
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
            coordinator.onDismiss = { [weak self] in
                print("did dismiss route \(route)")
                self?.clear(route: route)
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



