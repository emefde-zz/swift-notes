//
//  Cache.swift
//  ReactiveApp
//
//  Created by Mateusz Fidos on 31/05/2021.
//

import Foundation


protocol Cache {

    subscript<Type>(key: CacheKey) -> Type? { get set }

    func save<Type>(key: CacheKey, value: Type)

    func load<Type>(key: CacheKey) -> Type?

    func delete(key: CacheKey)

}
