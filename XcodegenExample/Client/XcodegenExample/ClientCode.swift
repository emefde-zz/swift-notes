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
