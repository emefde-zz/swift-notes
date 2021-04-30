import Foundation


protocol UserBlueprint {
    var id: String { get }
    var name: String { get }
    var email: String { get }
    var token: String? { get }
}

struct User: UserBlueprint {
    let id: String
    let name: String
    let email: String
    let token: String?
}

final class GameService {

    let user: UserBlueprint

    init(user: UserBlueprint) {
        self.user = user
    }

    func checkToken(_ token: String?, completion: @escaping (Bool) -> Void) {
        //make some call to validate current token
        completion(token != nil)
    }

    func fetchToken() -> UserBlueprint {
        print("fetched new token")
        return User(id: user.id, name: user.name, email: user.email, token: "new.token")
    }

    func fetchGameLibrary() {
        print("fetching game lib")
    }

    func fetchLastGame() {
        print("fetching last active game")
    }

    func fetchFriendsList() {
        print("fetching friends list")
    }

}

class GameServiceFacade {

    let gameService: GameService

    init(gameService: GameService) {
        self.gameService = gameService
    }

    func loadUserData(_ user: UserBlueprint) {
        gameService.checkToken(user.token) { [weak gameService] isTokenValid in
            if isTokenValid {
                gameService?.fetchGameLibrary()
                gameService?.fetchLastGame()
                gameService?.fetchFriendsList()
            } else {
                gameService?.fetchToken()
                gameService?.fetchGameLibrary()
                gameService?.fetchLastGame()
                gameService?.fetchFriendsList()
            }
        }
    }

}

// or with protocols

protocol GameServiceProtocolFacade {
    func loadUserData(_ user: UserBlueprint)
}


extension GameService: GameServiceProtocolFacade {

    func loadUserData(_ user: UserBlueprint) {
        checkToken(user.token) { [weak self] isTokenValid in
            if isTokenValid {
                self?.fetchGameLibrary()
                self?.fetchLastGame()
                self?.fetchFriendsList()
            } else {
                self?.fetchToken()
                self?.fetchGameLibrary()
                self?.fetchLastGame()
                self?.fetchFriendsList()
            }
        }
    }

}
