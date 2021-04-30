import Foundation

class CountOperation: Operation {

    let to: Int

    init(to: Int) {
        self.to = to
    }

    override func main() {
        guard !isCancelled else { return }
        (0...to).forEach(count)
    }

    private func count(_ c: Int) {
        print("Counting numer \(c)")
    }

}

let count100Operation = CountOperation(to: 100)
let count20Operation = CountOperation(to: 20)
let count50Operation = CountOperation(to: 50)

let countQ = OperationQueue()

// new way:

let completion = {
    print("all count operations are done")
}

//countQ.addOperations(
//    [count100Operation, count50Operation, count20Operation],
//    waitUntilFinished: false
//)

//countQ.addOperation(count100Operation)
//countQ.addOperation(count50Operation)
//countQ.addOperation(count20Operation)
//countQ.addBarrierBlock(completion) // always goes as the last call

//old way:

extension Array where Element: Operation {

    func onCompletion(_ completion: @escaping () -> Void) {
        let completionBlock = BlockOperation(block: completion)
        forEach { completionBlock.addDependency($0) }
        OperationQueue().addOperation(completionBlock) // which queue doesnt mater, any q will be ok, it's just to call the completion
    }

}

//let operations = [count100Operation, count50Operation, count20Operation]
//operations.onCompletion(completion)
//
//countQ.addOperations(operations, waitUntilFinished: false)


// extension operation queue way:

//protocol CompletableOperations {
//
//    func addOperations(_ ops: [Operation], waitUntilFinished: Bool, completion: @escaping () -> Void)
//
//}
//
//extension OperationQueue: CompletableOperations {
//
//    func addOperations(
//        _ ops: [Operation],
//        waitUntilFinished: Bool,
//        completion: @escaping () -> Void
//    ) {
//        addOperations(ops, waitUntilFinished: waitUntilFinished)
//        addBarrierBlock(completion)
//    }
//
//}
//
//let operations = [count100Operation, count50Operation, count20Operation]
//countQ.addOperations(operations, waitUntilFinished: false, completion: completion)

// some fun with chaining calls:


protocol ChainableOperations {

    func addOperations(operations: [Operation], waitUntilFinished: Bool) -> OperationQueue
    func onCompletion(_ completion: @escaping () -> Void) -> OperationQueue

}

extension OperationQueue: ChainableOperations {

    func addOperations(operations: [Operation], waitUntilFinished: Bool) -> OperationQueue {
        addOperations(operations, waitUntilFinished: waitUntilFinished)
        return self
    }

    @discardableResult
    func onCompletion(_ completion: @escaping () -> Void) -> OperationQueue {
        addBarrierBlock(completion)
        return self
    }

}

let operations = [count100Operation, count50Operation, count20Operation]

countQ
    .addOperations(
        operations: operations,
        waitUntilFinished: false
    )
    .onCompletion(completion)
