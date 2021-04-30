import Foundation

//The problem:

func count(to: Int) {
    let operationQ = DispatchQueue(label: "side.quest.q", attributes: .concurrent)
    operationQ.async {
        (0...to).forEach { print("\($0) $$")}
    }
}

let operationQ = OperationQueue()
//let operation1 = BlockOperation {
//    count(to: 20)
//}
//let operation2 = BlockOperation {
//    count(to: 100)
//}
//
//operation2.addDependency(operation1)
//operationQ.addOperations([operation1, operation2], waitUntilFinished: false)

//Desc: even though we added a dependency between two operations, operation q executes operation 1 and move to operation 2
//this happens becase count is done on a separate q asynchronously so it doesn't wait for the operation to finis
//operation is considered as finish because count returns immidiately after dispatchin to side.quest.q

//to resolve this asynchronous issue we need to create custom async operation and manage operation state manually

//Solution:

class Counter {

    let to: Int

    init(to: Int) {
        self.to = to
    }

    func count(completion: @escaping () -> Void) -> Void {
        let operationQ = DispatchQueue(label: "counter.q", attributes: .concurrent)
        operationQ.async { [weak self] in
            guard let self = self else { return }
            (0...self.to).forEach {
                print("\($0) $$")
            }
            print("did finish counting")
            completion()
        }
    }

}


class AsynchronousOperation: Operation {

    enum OperationState: String {
        case isReady
        case isExecuting
        case isFinished
    }

    //make state an atomic property so that read write actions can happen one at a time
    private let atomic = DispatchQueue(label: "async.operation.atomic.q", attributes: .concurrent)

    /*
     In willSet we inform the operation queue that the property for the current state and the next state will change.
     In didSet we then inform the operation queue that the property for the previous state and the new state has changed.
     */

    private var currentState: OperationState = .isReady

    var state: OperationState {
        get {
            atomic.sync(flags: .barrier) {
                return currentState
            }
        }
        set {
            let oldValue = state
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
            atomic.sync(flags: .barrier) {
                currentState = newValue
            }
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { state == .isExecuting }
    override var isFinished: Bool { state == .isFinished }

    override func start() {
        guard !isCancelled else { return }
        state = .isExecuting
        main()
    }

    override func cancel() {
        state = .isFinished
    }

}

class ExampleCountOperation: AsynchronousOperation {

    let counter: Counter

    init(counter: Counter) {
        self.counter = counter
    }

    override func main() {
        super.main()
        counter.count { [weak self] in self?.state = .isFinished }
    }

}

let operation1 = ExampleCountOperation(counter: Counter(to: 20))
let operation2 = ExampleCountOperation(counter: Counter(to: 50))

operation1.completionBlock = { print("Did finish operation 1") }
operation2.completionBlock = { print("Did finish operation 2") }

operation2.addDependency(operation1)
operationQ.addOperation(operation1)
operationQ.addOperation(operation2)



