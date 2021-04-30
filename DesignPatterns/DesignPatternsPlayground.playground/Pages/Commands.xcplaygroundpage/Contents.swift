import Foundation

protocol Cancellable {
    func cancel()
}

protocol Command {

    associatedtype Success
    associatedtype Failure: Error

    func execute(completion: @escaping (Result<Success, Failure>) -> Void) -> Cancellable

}

extension Command {
    func execute() -> Cancellable {
        execute { _ in }
    }
}

//type erased command

final class AnyCommand<Success, Failure: Error>: Command {

    private let anyExecute: (@escaping (Result<Success, Failure>) -> Void) -> Cancellable

    init<C: Command>(command: C) where C.Success == Success, C.Failure == Failure {
        self.anyExecute = command.execute
    }

    func execute(completion: @escaping (Result<Success, Failure>) -> Void) -> Cancellable {
        anyExecute(completion)
    }
}

final class CommandBuilder<Success, Failure: Error> {

    private let command: AnyCommand<Success, Failure>

    private init<C: Command>(command: C) where C.Success == Success, C.Failure == Failure {
        self.command = AnyCommand(command: command)
    }

    static func first<C: Command>(_ command: C) -> Self where C.Success == Success, C.Failure == Failure {
        .init(command: command)
    }

    static func then<C: Command>(_ command: C) -> Self where C.Success == Success, C.Failure == Failure {
        command = 
    }

}
