//
//  ClientCode.swift
//  Client
//
//  Created by Mateusz Fidos on 04/05/2021.
//  Copyright © 2021 mfd corp. All rights reserved.
//

import UIKit
import Foundation
import ProfilesFeature
import NetworkingModule



// just to test if setup was successfull


@UIApplicationMain
class ClientCode: UIResponder, UIApplicationDelegate {


    func fetchProfiles() {
        let manager: ProfilesProvider = ProfileManager()
        manager.fetchProfiles { $0.forEach { print($0.name) } }
    }

    func fetchData() {
        let sharedInstance: APIClient = ConcreteAPIClient.shared
        sharedInstance.fetchData()
    }

}


//DIC: Dependency Injection Container


protocol Registry {
    func register<T>(type: T.Type, service: T)
}

protocol Resolver {
    func resolve<T>(type: T.Type) -> T?
}

protocol KeyIdentifiable {
    func key<T>(_ type: T.Type) -> ObjectIdentifier
}


typealias Container = Registry & Resolver & KeyIdentifiable

protocol ModuleConfiguration {

    func register(using registry: Registry)
    func start(with resolver: Resolver) throws

}

final class AppDependencyContainer: Container {

    private var dependencies: [ObjectIdentifier: Any] = [:]

    func register<T>(type: T.Type, service: T) {
        dependencies[key(type)] = service
    }

    func resolve<T>(type: T.Type) -> T? {
        dependencies[key(type)] as? T
    }

    func key<T>(_ type: T.Type) -> ObjectIdentifier {
        ObjectIdentifier(type)
    }

}

protocol NetworkingService { }
final class NetworkingAdapter: NetworkingService { }


final class ProfilesModuleConfiguration: ModuleConfiguration {

    enum ResolverError: Error {
        case couldNotResolveDependency
        var localizedDescription: String {
            switch self {
            case .couldNotResolveDependency:
                return "Resolver could not resolve the dependency. All dependencies MUST be set up properly"
            }
        }
    }

    private(set) var networkingService: NetworkingService!

    func register(using registry: Registry) {
        registry.register(type: NetworkingService.self, service: NetworkingAdapter())
    }

    func start(with resolver: Resolver) throws {
        guard let networkingService = resolver.resolve(type: NetworkingService.self)
        else {
            throw ResolverError.couldNotResolveDependency
        }

        self.networkingService = networkingService
    }

}
