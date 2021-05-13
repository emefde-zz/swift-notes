//
//  ProfileManager.swift
//  ProfilesFeature
//
//  Created by Mateusz Fidos on 04/05/2021.
//  Copyright © 2021 mfd corp. All rights reserved.
//

import Foundation

let profiles = [
    Profile(id: UUID(), name: "Mabel"),
    Profile(id: UUID(), name: "Dipper")
]


public struct Profile {

    public let id: UUID
    public let name: String

}


public protocol ProfilesProvider {

    func fetchProfiles(completion: @escaping ([Profile]) -> Void)

}


final public class ProfileManager: ProfilesProvider {

    public init() {}

    public func fetchProfiles(completion: @escaping ([Profile]) -> Void) {
        completion(profiles)
    }

}
