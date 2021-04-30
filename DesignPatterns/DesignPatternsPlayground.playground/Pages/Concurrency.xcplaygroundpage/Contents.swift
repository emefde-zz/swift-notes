import Foundation


let sideQ = DispatchQueue(label: "side.queue")

print("A")

DispatchQueue.main.async {
    print("B")

    sideQ.sync {
        print("C")
    }

    sideQ.async {
        print("D")
    }

    sideQ.sync {
        print("ssss")
    }

    sideQ.sync { // 1
        print("eeee")
        sideQ.sync { // 2
            print("deadlock") //will never print this
            //here we have deadlock because "2" is waiting for "1" to finish so it can start running
            //but at the same time "1" cannot finish before "2" starts and releases controll to caller thread
        }

        print("will never get here")
    }

    print("E")
}


let sideQC = DispatchQueue(label: "side.queue", attributes: .concurrent)

print("A")

DispatchQueue.main.async {
    print("B")

    sideQC.sync {
        print("C")
    }

    sideQC.async {
        print("D")
    }

    sideQC.sync {
        print("ssss")
    }

    sideQC.sync { // 1
        print("eeee")
        sideQC.async { // 2
            Thread.sleep(forTimeInterval: 1)
            print("deadlock")
        }

        print("will never get here")
    }

    print("E")
}


print("A")

DispatchQueue.main.async {
    print("B")

    DispatchQueue.main.async {
        print("C")
        DispatchQueue.main.async {
            print("D")
        }
    }

    DispatchQueue.global().sync {
        print("E")

        DispatchQueue.main.sync { //deadlock
            print("F")
        }
    }

    print("G")
}
