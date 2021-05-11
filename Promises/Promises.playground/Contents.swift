import Foundation

class Future<Value> {

    typealias Result = Swift.Result<Value, Error>

    fileprivate var result: Result? {
        didSet {
            result.map(report)
        }
    }

    private var callbacks: [(Result) -> Void] = []


    func observe(using callback: @escaping (Result) -> Void) {
        if let result = result {
            return callback(result)
        }

        callbacks.append(callback)
    }


    private func report(result: Result) {
        callbacks.forEach { $0(result) }
        callbacks.removeAll()
    }

}


class Promise<Value>: Future<Value> {

    init(value: Value? = nil) {
        super.init()
        result = value.map(Result.success)
    }


    func resolve(with value: Value) {
        result = .success(value)
    }


    func resolve(with failure: Error) {
        result = .failure(failure)
    }

}

extension URLSession {

    func request(url: URL) -> Future<Data> {
        let promise = Promise<Data>()

        let task = dataTask(with: url) { (data, _, error) in
            if let error = error {
                promise.resolve(with: error)
            } else if let data = data {
                promise.resolve(with: data)
            }
        }

        task.resume()

        return promise
    }

}


struct User: Decodable {
    let name: String
    let city: String
}


extension URLSession {

    enum ParsingError: Error {
        case couldNotParseResonse
    }

    func fetchUsers() -> Future<[User]> {
        let promise = Promise<[User]>()
        let url = URL(string: "https://mocki.io/v1/d4867d8b-b5d5-4a48-a4ab-79131b5809b8")!
        let task = dataTask(with: url) { (data, _, error) in
            if let error = error {
                promise.resolve(with: error)
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let users = try decoder.decode([User].self, from: data)
                    promise.resolve(with: users)
                } catch {
                    promise.resolve(with: error)
                }
            }
        }

        task.resume()

        return promise
    }

}

let userFuture = URLSession.shared.fetchUsers()
userFuture.observe {
    switch $0 {
    case .failure(let error):
        print(error)
    case .success(let users):
        users.forEach { print($0.name) }
    }
}


extension Future {

    func chained<T>(
        closure: @escaping (Value) throws -> Future<T>
    ) -> Future<T> {
        let promise = Promise<T>()
        observe {
            switch $0 {
            case .success(let value):
                do {
                    let future = try closure(value)
                    future.observe { result in
                        switch result {
                        case .success(let value):
                            promise.resolve(with: value)
                        case .failure(let error):
                            promise.resolve(with: error)
                        }
                    }
                } catch {
                    promise.resolve(with: error)
                }
            case .failure(let error):
                promise.resolve(with: error)
            }
        }

        return promise
    }

}

extension Future {

    func transformed<T>(
        closure: @escaping (Value) throws -> T
    ) -> Future<T> {
        chained {
            try Promise(value: closure($0))
        }
    }

}


extension Future where Value == Data {

    func decoded<T: Decodable>(
        as type: T.Type = T.self,
        using decoder: JSONDecoder = .init()
    ) -> Future<T> {
        transformed {
            try decoder.decode(type, from: $0)
        }
    }

}

protocol Savable {
    func save()
}

extension Savable {
    func save() {
        print("Saved item in database")
    }
}

extension User: Savable { }
extension Array: Savable where Element: Savable {}

extension Future where Value: Savable {

    func saved() -> Future<Value> {
        chained { value in
            let promise = Promise<Value>()
            value.save()
            promise.resolve(with: value)
            return promise
        }
    }
}

class UsersLoader {

    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    func loadUsers() -> Future<[User]> {
        let url = URL(string: "https://mocki.io/v1/d4867d8b-b5d5-4a48-a4ab-79131b5809b8")!
        return urlSession.request(url: url)
            .decoded(as: [User].self)
            .saved()
    }

}

let loader = UsersLoader()
let users = loader.loadUsers()
users.observe {
    switch $0 {
    case .failure(let error):
        print(error)
    case .success(let users):
        users.forEach { print($0.name) }
    }
}
