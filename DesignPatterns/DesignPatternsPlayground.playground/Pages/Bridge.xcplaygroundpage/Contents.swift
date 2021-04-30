import Foundation

protocol UserBlueprint {
    var name: String { get }
}

struct User: UserBlueprint {
    let name: String
}

protocol LoginFeature {
    var description: String { get }
    func logIn(_ user: UserBlueprint) -> Bool
}

//Implementation
class FacebookLoginFeature: LoginFeature {

    var description: String { "Facebook login" }

    func logIn(_ user: UserBlueprint) -> Bool {
        //.Log in....
        true
    }
}

//Implementation
class AppleLoginFeature: LoginFeature {

    var description: String { "Apple login" }

    func logIn(_ user: UserBlueprint) -> Bool {
        //.Log in....
        true
    }
}

protocol LoginFeatureProvider {

    func accept(_ feature: LoginFeature)
    func logIn(_ user: UserBlueprint) -> Bool

}

//Abstraction
class ClientCode: LoginFeatureProvider {

    var loginFeature: LoginFeature?

    func accept(_ feature: LoginFeature) {
        loginFeature = feature
    }

    func logIn(_ user: UserBlueprint) -> Bool {
        guard let feature = loginFeature else { return false }
        print("Logged in user: \(user.name), via: \(feature.description)")
        return feature.logIn(user)
    }

}

let clientCode = ClientCode()
let facebookLogin = FacebookLoginFeature()
let appleLogin = AppleLoginFeature()
let user = User(name: "Bridge")

clientCode.accept(appleLogin)
clientCode.logIn(user)

clientCode.accept(facebookLogin)
clientCode.logIn(user)
