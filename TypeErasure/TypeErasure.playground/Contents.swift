import Foundation

protocol Increasable {
    func increase()
}

class AnyIncreasable: Increasable {

    private let wrapped: Increasable

    init(wrapped: Increasable) {
        self.wrapped = wrapped
    }

    func increase() {
        wrapped.increase()
    }

}

class Age: Increasable {

    private var myAge: Int = 30

    func increase() {
        myAge += 1
    }

}

let age: Increasable = Age()
age.increase()

print(type(of: age)) // type of age is known

//we can use type erasure to erase the type information
//quite useful when creating APIs and framweorks when we want to hide implementation details

let typeErasedAge = AnyIncreasable(wrapped: Age())
typeErasedAge.increase()

print(type(of: typeErasedAge)) // type of age is not available, we get AnyIncreasable as a type


//type erasure is helpful when dealing with protocol that have assoc values and generics in them
//since swift 5.4 those restricitions are a bit lighter but still doesn't remove TE 100%

//let's say you have a command protocol
//commadns result can be a success or a failure
//success is generic over a type and failure is just an error

protocol Command {

    associatedtype Success
    associatedtype Failure: Error

    func execute(completion: @escaping (Result<Success, Failure>) -> Void)
}

extension Command {
    func execute() {
        execute { _ in }
    }
}


//class CommandQueue {
//
////    private var commands: [Command] = [] // Protocol 'Command' can only be used as a generic constraint because it has Self or associated type requirements
////
////    func addCommand(_ c: Command) { // Protocol 'Command' can only be used as a generic constraint because it has Self or associated type requirements
////        commands.append(c)
////    }
//
//}

// we can resolve the second problem by using command as a generic constraint:


class CommandQueue {

    /*
     ...
     */

    func addCommand<C: Command>(_ command: C) {

    }

}

//but we're still not able to do much with it since we cannot assign it to a property or store it in an array
//we'd still get the `Protocol 'Command' can only be used as a generic constraint because it has Self or associated type requirements` error

struct AnyCommand<Success, Failure: Swift.Error>: Command {

    private let anyExecute: (@escaping (Result<Success, Failure>) -> Void) -> Void

    init<C: Command>(command: C) where C.Success == Success, C.Failure == Failure {
        self.anyExecute = command.execute
    }

    func execute(completion: @escaping (Result<Success, Failure>) -> Void) {
        anyExecute(completion)
    }

}

//with type erase command we can now do this


class AnyCommandQueue<Success, Failure: Error> {

    private typealias TypeErasedCommand = AnyCommand<Success,Failure>

    private var commands: [TypeErasedCommand] = []

    func addCommand<C: Command>(_ command: C) where C.Success == Success, C.Failure == Failure {
        commands.append(AnyCommand(command: command))
    }

    func executeAll() {
        commands.forEach { $0.execute() }
    }

    func purgeAll() {
        commands.removeAll()
    }

}


//unfortunately this has few downsides. We had to introduce new type AnyCommand and to use it we had to turn
//CommandQueue to be generic over Succss and Failure which means we won't be able to put any type of command in
//and we will need to specify those associated types on q creation


// like this:

//let anyCommandQueue: AnyCommandQueue = AnyCommandQueue() // Explicitly specify the generic arguments to fix this issue

// we have to do it like this:

let anyCommandQueue = AnyCommandQueue<Int, Never>()


//ironically to be able to put any command in our queue we would need to type erase it also
//you cannot just pass any commad there like so:

struct PrintCommand: Command {

    enum PrintError: Error {
        case messageEmptyError
    }

    let message: String

    init(message: String) {
        self.message = message
    }

    func execute(completion: @escaping (Result<String, PrintError>) -> Void) {
        if message.isEmpty {
            print("message cannot be empty")
            completion(.failure(.messageEmptyError))
        } else {
            print(message)
            completion(.success(message))
        }
    }

}


struct AddOneCommand: Command {

    private var value: Int

    init(value: Int) {
        self.value = value
    }

    func execute(completion: @escaping (Result<Int, Never>) -> Void) {
        print(value + 1)
        completion(.success(value + 1))
    }

}

let printCommand = PrintCommand(message: "print me please")
let addOneCommand = AddOneCommand(value: 12)

//anyCommandQueue.addCommand(printCommand) //won't work
anyCommandQueue.addCommand(addOneCommand) // this works

anyCommandQueue.executeAll()


//type erasue using closures:
//with type erasue with closures we capture all type and implementation details within a closure that has no generic
//assosciates and accepts non generic input or even Void
//and we use those closures later to store, reference and pass around functionalitites that we know nothing about
//in any detail

class ClosureErasedCommandQueue {

    typealias Eraser = () -> Void

    private(set) var commands: [Eraser] = []

    func addCommand<C: Command>(_ command: C) {
        let eraser = {
            command.execute()
        }

        commands.append(eraser)
    }

    func executeAll() {
        commands.forEach { $0() }
    }

    func purgeAll() {
        commands.removeAll()
    }

}

//now we can pass any type of command and it will get executed:

let closureErasedCommandQueue = ClosureErasedCommandQueue()
closureErasedCommandQueue.addCommand(printCommand)
closureErasedCommandQueue.addCommand(addOneCommand)

closureErasedCommandQueue.executeAll()
closureErasedCommandQueue.purgeAll()

print(closureErasedCommandQueue.commands.isEmpty)


//instead of using closures directly in ClosureErasedCommandQueue
//we can perfor so called external specialization on Command

struct SpecializedCommand {

    let closure: (@escaping () -> Void) -> Void

    func execute(_ handler: @escaping () -> Void) {
        closure(handler)
    }

    func execute() {
        closure { }
    }

}

//then we extend our command like this:

extension Command {

    func makeCommand(with handler: @escaping (Result<Success, Failure>) -> Void) -> SpecializedCommand {
        SpecializedCommand { executor in
            self.execute { result in
                handler(result)
                executor()
            }
        }
    }

    func makeCommand() -> SpecializedCommand {
        SpecializedCommand { executor in
            self.execute { _ in executor() }
        }
    }

}


class SpecializedCommandQueue {

    private(set) var commands: [SpecializedCommand] = []

    func addCommand(_ command: SpecializedCommand) {
        commands.append(command)
    }

    func executeAll() {
        commands.forEach { $0.execute() }
    }

    func purgeAll() {
        commands.removeAll()
    }

}


let specializedCommandQueue = SpecializedCommandQueue()
let specializedPrintCommand = printCommand.makeCommand()
let specializedAddOneCommand = addOneCommand.makeCommand()

specializedCommandQueue.addCommand(specializedPrintCommand)
specializedCommandQueue.addCommand(specializedAddOneCommand)

specializedCommandQueue.executeAll()
specializedCommandQueue.purgeAll()

print(specializedCommandQueue.commands.isEmpty)
