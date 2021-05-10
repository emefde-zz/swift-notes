import Foundation

class Future<Value, Failure: Error> {

    typealias Result = Swift.Result<Value, Failure>

    fileprivate var result: Result?
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


class Promise<Value, Failure: Error>: Future<Value, Failure> {

    init(value: Value? = nil) {
        super.init()
        result = value.map(Result.success)
    }


    func resolve(with value: Value) {
        result = .success(value)
    }


    func resolve(with failure: Failure) {
        result = .failure(failure)
    }

}


let neverFailingPromise = Promise<Int, Never>()
