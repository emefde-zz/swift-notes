//
//  APIClient.swift
//  NetworkingModule
//
//  Created by Mateusz Fidos on 04/05/2021.
//  Copyright © 2021 mfd corp. All rights reserved.
//

import Foundation


public protocol APIClient {

    static var shared: APIClient { get }

    func fetchData()

}


public final class ConcreteAPIClient: APIClient {

    public static let shared: APIClient = ConcreteAPIClient()

    private init() { }

    public func fetchData() {
        print("Did fetch data")
    }

}

