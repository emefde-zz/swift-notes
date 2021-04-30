//import Foundation
//
////for easier presentation
//struct CORError: Error {
//    var isServerError: Bool
//    var isUserError: Bool
//}
//
//protocol ErrorHandler: AnyObject {
//    var next: ErrorHandler? { get set }
//    func handle(_ error: CORError)
//}
//
//
//protocol ErrorHandlerBuilder {
//    static func first(_ handler: ErrorHandler) -> Self
//    func then(_ handler: ErrorHandler) -> Self
//    func build() -> ErrorHandler
//}
//
//final class BaseErrorBuilder: ErrorHandlerBuilder {
//
//    private let rootHandler: ErrorHandler
//    private var nextHandler: ErrorHandler?
//
//    private init(handler: ErrorHandler) {
//        self.rootHandler = handler
//        self.nextHandler = handler
//    }
//
//    static func first(_ handler: ErrorHandler) -> Self {
//        .init(handler: handler)
//    }
//
//    func then(_ handler: ErrorHandler) -> Self {
//        nextHandler?.next = handler
//        nextHandler = handler
//        return self
//    }
//
//    func build() -> ErrorHandler {
//        rootHandler
//    }
//
//}
//
//class ServerErrorHandler: ErrorHandler {
//    var next: ErrorHandler?
//    func handle(_ error: CORError) {
//        guard error.isServerError else {
//            next?.handle(error)
//            return
//        }
//        print("Server error got handled here")
//    }
//}
//
//class UserErrorHandler: ErrorHandler {
//    var next: ErrorHandler?
//    func handle(_ error: CORError) {
//        guard error.isUserError else {
//            next?.handle(error)
//            return
//        }
//        print("User error got handled here")
//    }
//}
//
//class GenericErrorHandler: ErrorHandler {
//    var next: ErrorHandler?
//    func handle(_ error: CORError) {
//        guard !error.isServerError && !error.isUserError else {
//            next?.handle(error)
//            return
//        }
//        print("Generic error got handled here")
//    }
//}
//
//let error: CORError = CORError(isServerError: false, isUserError: false)
//let serverError: CORError = CORError(isServerError: true, isUserError: false)
//let userError: CORError = CORError(isServerError: false, isUserError: true)
//
//let handler = BaseErrorBuilder
//    .first(ServerErrorHandler())
//    .then(UserErrorHandler())
//    .then(GenericErrorHandler())
//    .build()
//
//handler.handle(error)
//
//handler.handle(serverError)
//
//handler.handle(userError)
//
//

import Foundation

//for easier presentation
struct CORError: Error {
    var isServerError: Bool
    var isUserError: Bool
}

protocol ErrorChainable {
    var next: ChainableErrorHandler? { get set }
}

protocol ErrorHandler: AnyObject {
    func handle(_ error: CORError)
}

typealias ChainableErrorHandler = ErrorHandler & ErrorChainable

protocol ErrorHandlerBuilder {
    static func first(_ handler: ChainableErrorHandler) -> Self
    func then(_ handler: ChainableErrorHandler) -> Self
    func build() -> ChainableErrorHandler
}

class ErrorHandlerProxy: ErrorHandler {

    private var nextHandler: ChainableErrorHandler

    init(nextHandler: ChainableErrorHandler) {
        self.nextHandler = nextHandler
    }

    func then(_ handler: ChainableErrorHandler) {
        nextHandler.next = handler
        nextHandler = handler
    }

    func handle(_ error: CORError) {
        nextHandler.handle(error)
    }
}

final class BaseErrorBuilder: ErrorHandlerBuilder {

    private let root: ChainableErrorHandler
    private let proxy: ErrorHandlerProxy

    private init(handler: ChainableErrorHandler) {
        self.root = handler
        self.proxy = ErrorHandlerProxy(nextHandler: handler)
    }

    static func first(_ handler: ChainableErrorHandler) -> Self {
        .init(handler: handler)
    }

    func then(_ handler: ChainableErrorHandler) -> Self {
        proxy.then(handler)
        return self
    }

    func build() -> ChainableErrorHandler { root }

}

class ServerErrorHandler: ChainableErrorHandler {
    var next: ChainableErrorHandler?
    func handle(_ error: CORError) {
        guard error.isServerError else {
            next?.handle(error)
            return
        }
        print("Server error got handled here")
    }
}

class UserErrorHandler: ChainableErrorHandler {
    var next: ChainableErrorHandler?
    func handle(_ error: CORError) {
        guard error.isUserError else {
            next?.handle(error)
            return
        }
        print("User error got handled here")
    }
}

class GenericErrorHandler: ChainableErrorHandler {
    var next: ChainableErrorHandler?
    func handle(_ error: CORError) {
        guard !error.isServerError && !error.isUserError else {
            next?.handle(error)
            return
        }
        print("Generic error got handled here")
    }
}

let error: CORError = CORError(isServerError: false, isUserError: false)
let serverError: CORError = CORError(isServerError: true, isUserError: false)
let userError: CORError = CORError(isServerError: false, isUserError: true)

let handler = BaseErrorBuilder
    .first(ServerErrorHandler())
    .then(UserErrorHandler())
    .then(GenericErrorHandler())
    .build()

handler.handle(error)

handler.handle(serverError)

handler.handle(userError)
