//
//  CodableCaching.swift
//  ReactiveApp
//
//  Created by Mateusz Fidos on 31/05/2021.
//

import Foundation


protocol CodableCaching {

    subscript<Type>(key: CacheKey) -> Type? where Type: Codable { get set }

    func save<Type>(key: CacheKey, value: Type) where Type: Codable

    func load<Type>(key: CacheKey) -> Type? where Type: Codable

    func delete(key: CacheKey)

}


extension UserDefaults: CodableCaching {

    public subscript<Type>(key: CacheKey) -> Type? where Type: Codable {
        get { load(key: key) }
        set {
            guard let value = newValue else {
                delete(key: key)
                return
            }
            save(key: key, value: value)
        }
    }


    func save<Type>(key: CacheKey, value: Type) where Type: Codable {
        let data = try? JSONEncoder().encode([value])
        set(data, forKey: key.rawValue)
    }


    func load<Type>(key: CacheKey) -> Type? where Type: Codable {
        guard let data = data(forKey: key.rawValue) else { return nil }
        return (try? JSONDecoder().decode([Type].self, from: data))?.first
    }


    func delete(key: CacheKey) {
        removeObject(forKey: key.rawValue)
    }
}
