//
//  CacheKey.swift
//  ReactiveApp
//
//  Created by Mateusz Fidos on 31/05/2021.
//

import Foundation


public struct CacheKey: ExpressibleByStringLiteral {

    public let rawValue: String


    public init(stringLiteral value: String) {
        self.rawValue = value
    }

}
