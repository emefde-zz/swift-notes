import Foundation


//DIC: Dependency Injection Container


protocol Registry {
    func register<T>(type: T.Type, service: Any)
}

protocol Resolver {
    func resolve<T>(_ type: T.Type) -> T
}


typealias Locator = Registry & Resolver

protocol ModuleConfiguration {

    func register(using registry: Registry)
    func start(using resolver: Resolver)

}

class ExampleModuleConfiguration: ModuleConfiguration {

    func register(using registry: Registry) {
        <#code#>
    }

    func start(using resolver: Resolver) {
        <#code#>
    }

}
