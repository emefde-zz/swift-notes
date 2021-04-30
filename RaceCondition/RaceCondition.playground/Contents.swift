import UIKit
import Foundation

///To test any of examples uncomment cash machine calls


enum CashMachineType: String {
    case first, second, other
}

protocol CashMachine {
    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType)
}

final class BankAccount {

    private(set) var amount: Int

    init(amount: Int) {
        self.amount = amount
    }

    func updateAmount(_ amount: Int) {
        print("Updating amount")
        print("----------------------------------------")
        self.amount = amount
    }

}

var myAccount = BankAccount(amount: 800)

func getAmount(_ account: BankAccount?) {
    print("Current ballance is: \(account?.amount ?? 0)")
    print("----------------------------------------")
}

class BaseCashMachine: CashMachine {

    let bankAccount: BankAccount

    init(bankAccount: BankAccount) {
        self.bankAccount = bankAccount
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        print("Making withdraw using cash machine: \(machine)")
        print("----------------------------------------")
        let currentAmount = bankAccount.amount
        guard currentAmount >= amount else {
            print("Insufficient funds, operation couldn't be completed")
            print("----------------------------------------")
            return
        }

        //do some other time expensive operation
        Thread.sleep(forTimeInterval: .random(in: 0...3))

        //update amount
        bankAccount.updateAmount(currentAmount - amount)
        getAmount(bankAccount)
    }

}

let cashMachine = BaseCashMachine(bankAccount: myAccount)

//this works fine as we're working on a main thread which is a serial one
//cashMachine.withdraw(800)
//cashMachine.withdraw(100)

// but what if we start making withdrawals from different threads:

let firstCashMachine = DispatchQueue(label: "first.cash.machine.thread", attributes: .concurrent)
let secondCashMachine = DispatchQueue(label: "second.cash.machine.thread", attributes: .concurrent)

//here we make a withdrawal, quite big ammount on some other thread that just simulates
//a case where someone could be using two different atms at a time
//firstCashMachine.async {
//    cashMachine.withdraw(600, usingCashMachine: .first)
//}

//here we make the same withdrawl just from a different machine
//this should trigger insufficient funds warning
//secondCashMachine.async {
//    cashMachine.withdraw(400, usingCashMachine: .second)
//}

//Thread safe cash machine

class SerialCashMachine: CashMachine {

    let bankAccount: BankAccount
    let dispatchQ: DispatchQueue

    init(
        bankAccount: BankAccount,
        dispatchQ: DispatchQueue = DispatchQueue(label: "thread.safe.dispatch.q")
    ) {
        self.bankAccount = bankAccount
        self.dispatchQ = dispatchQ
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        dispatchQ.async { [weak self] in
            print("Making withdraw using cash machine: \(machine)")
            print("----------------------------------------")

            guard let currentAmount = self?.bankAccount.amount, currentAmount >= amount else {
                print("Insufficient funds, operation couldn't be completed")
                print("----------------------------------------")
                return
            }

            //do some other time expensive operation
            Thread.sleep(forTimeInterval: .random(in: 0...3))

            //update amount
            self?.bankAccount.updateAmount(currentAmount - amount)
            getAmount(self?.bankAccount)
        }
    }

}

let newAccount = BankAccount(amount: 800)
let serialCashMachine = SerialCashMachine(bankAccount: newAccount)

//serialCashMachine.withdraw(600, usingCashMachine: .first)
//print("aaaaaaaa")
//serialCashMachine.withdraw(400, usingCashMachine: .second)


//firstCashMachine.async {
//    serialCashMachine.withdraw(600, usingCashMachine: .first)
//    print("aaaaaaaa")
//}


//secondCashMachine.async {
//    serialCashMachine.withdraw(400, usingCashMachine: .second)
//    print("aaaaaaaa")
//}

//serial sync will work too but it will block the current thread for the time of performing the task
//also you need to look out for performing sync operations on the same thread as it will result in deadlock
class SerialSyncCashMachine: CashMachine {

    let bankAccount: BankAccount
    let dispatchQ: DispatchQueue

    init(
        bankAccount: BankAccount,
        dispatchQ: DispatchQueue = DispatchQueue(label: "thread.safe.dispatch.q")
    ) {
        self.bankAccount = bankAccount
        self.dispatchQ = dispatchQ
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        print(Thread.current)
        dispatchQ.sync { [weak self] in
            print(Thread.current)
            print("Making withdraw using cash machine: \(machine)")
            print("----------------------------------------")

            guard let currentAmount = self?.bankAccount.amount, currentAmount >= amount else {
                print("Insufficient funds, operation couldn't be completed")
                print("----------------------------------------")
                return
            }

            //do some other time expensive operation
            Thread.sleep(forTimeInterval: .random(in: 0...3))

            //update amount
            self?.bankAccount.updateAmount(currentAmount - amount)
            getAmount(self?.bankAccount)
        }

    }

}

let serialSyncCashMachine = SerialSyncCashMachine(bankAccount: newAccount)

//blocks main thread
//serialSyncCashMachine.withdraw(600, usingCashMachine: .first)
//print("adsadasdasdssdad")
//serialSyncCashMachine.withdraw(400, usingCashMachine: .second)

//print(Thread.current)
//
//
//firstCashMachine.async {
//    print(Thread.current)
//    serialSyncCashMachine.withdraw(600, usingCashMachine: .first)
//    print("adsadasdasdssdad")
//    print(Thread.current)
//}
//
//print("adsadasdasdssdad")
//print(Thread.current)

//secondCashMachine.async {
//    serialSyncCashMachine.withdraw(400, usingCashMachine: .second)
//    print("adsadasdasdssdad")
//}


//example of deadlock:

//let sameQ = DispatchQueue(label: "same.q")
//let deadlockCashMachine = SerialSyncCashMachine(bankAccount: newAccount, dispatchQ: sameQ)
//
//sameQ.async {
//    print("adsadasdasdssdad")
//    deadlockCashMachine.withdraw(600, usingCashMachine: .first) // this will never get called
//    print("adsadasdasdssdad")
//    deadlockCashMachine.withdraw(400, usingCashMachine: .second)
//}


class ConcurrentCashMachine: CashMachine {

    let bankAccount: BankAccount
    let dispatchQ: DispatchQueue

    init(
        bankAccount: BankAccount,
        dispatchQ: DispatchQueue = DispatchQueue(label: "thread.safe.concurrent.dispatch.q", attributes: .concurrent)
    ) {
        self.bankAccount = bankAccount
        self.dispatchQ = dispatchQ
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        dispatchQ.async(flags: .barrier) { [weak self] in
            print("Making withdraw using cash machine: \(machine)")
            print("----------------------------------------")

            guard let currentAmount = self?.bankAccount.amount, currentAmount >= amount else {
                print("Insufficient funds, operation couldn't be completed")
                print("----------------------------------------")
                return
            }

            //do some other time expensive operation
            Thread.sleep(forTimeInterval: .random(in: 0...3))

            //update amount
            self?.bankAccount.updateAmount(currentAmount - amount)
            getAmount(self?.bankAccount)
        }
    }

}


let yetAnotherAccount = BankAccount(amount: 800)
let concurrentCashMachine = ConcurrentCashMachine(bankAccount: yetAnotherAccount)


//firstCashMachine.async {
//    concurrentCashMachine.withdraw(800, usingCashMachine: .first)
//}
//
//
//secondCashMachine.async {
//    concurrentCashMachine.withdraw(400, usingCashMachine: .second)
//}


// operation Q:

class SingleOperationQCashMachine: CashMachine {

    let bankAccount: BankAccount
    let operationQ: OperationQueue

    init(
        bankAccount: BankAccount,
        operationQ: OperationQueue
    ) {
        self.bankAccount = bankAccount
        self.operationQ = operationQ
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        operationQ.addOperation { [weak self] in
            print("Making withdraw using cash machine: \(machine)")
            print("----------------------------------------")

            guard let currentAmount = self?.bankAccount.amount, currentAmount >= amount else {
                print("Insufficient funds, operation couldn't be completed")
                print("----------------------------------------")
                return
            }

            //do some other time expensive operation
            Thread.sleep(forTimeInterval: .random(in: 0...3))

            //update amount
            self?.bankAccount.updateAmount(currentAmount - amount)
            getAmount(self?.bankAccount)
        }
    }

}

let operationQBankAccount = BankAccount(amount: 800)

let singleOperationQ = OperationQueue()
singleOperationQ.maxConcurrentOperationCount = 1

let operationQCashMachine = SingleOperationQCashMachine(
    bankAccount: operationQBankAccount,
    operationQ: singleOperationQ
)


//firstCashMachine.async {
//    operationQCashMachine.withdraw(800, usingCashMachine: .first)
//}


//secondCashMachine.async {
//    operationQCashMachine.withdraw(400, usingCashMachine: .second)
//}


class BarrierOperationQCashMachine: CashMachine {

    let bankAccount: BankAccount
    let operationQ: OperationQueue

    init(
        bankAccount: BankAccount,
        operationQ: OperationQueue
    ) {
        self.bankAccount = bankAccount
        self.operationQ = operationQ
    }

    func withdraw(_ amount: Int, usingCashMachine machine: CashMachineType = .other) {
        operationQ.addBarrierBlock { [weak self] in
            print("Making withdraw using cash machine: \(machine)")
            print("----------------------------------------")

            guard let currentAmount = self?.bankAccount.amount, currentAmount >= amount else {
                print("Insufficient funds, operation couldn't be completed")
                print("----------------------------------------")
                return
            }

            //do some other time expensive operation
            Thread.sleep(forTimeInterval: .random(in: 0...3))

            //update amount
            self?.bankAccount.updateAmount(currentAmount - amount)
            getAmount(self?.bankAccount)
        }
    }

}

let barrierOperationQBankAccount = BankAccount(amount: 800)
let barrierOperationQ = OperationQueue()

let barrierOperationQCashMachine = BarrierOperationQCashMachine(
    bankAccount: barrierOperationQBankAccount,
    operationQ: barrierOperationQ
)


//firstCashMachine.async {
//    operationQCashMachine.withdraw(800, usingCashMachine: .first)
//}


//secondCashMachine.async {
//    operationQCashMachine.withdraw(400, usingCashMachine: .second)
//}


// custom operation:

class WithdrawOperation: Operation {

    let cashMachine: CashMachine
    let cashMachineType: CashMachineType
    let amount: Int

    init(
        cashMachine: CashMachine,
        type: CashMachineType,
        amount: Int
    ) {
        self.cashMachine = cashMachine
        self.cashMachineType = type
        self.amount = amount
        super.init()
    }

    override func main() {
        guard !isCancelled else { return }
        cashMachine.withdraw(amount, usingCashMachine: cashMachineType)
    }

}

let baseBankAccount = BankAccount(amount: 800)
let baseCashMachine = BaseCashMachine(bankAccount: baseBankAccount)
let withdrawOperation1 = WithdrawOperation(cashMachine: baseCashMachine, type: .first, amount: 800)
let withdrawOperation2 = WithdrawOperation(cashMachine: baseCashMachine, type: .second, amount: 800)

withdrawOperation2.addDependency(withdrawOperation1) // comment this out and see what happens

let withdrawOperationQ = OperationQueue()

//withdrawOperationQ.addOperations([withdrawOperation1, withdrawOperation2], waitUntilFinished: true)

//firstCashMachine.async {
//    withdrawOperationQ.addOperation(withdrawOperation1)
//}
//
//secondCashMachine.async {
//    withdrawOperationQ.addOperation(withdrawOperation2)
//}

