import Foundation

//print("A") //1
////Odpalamy główny wątek
//DispatchQueue.main.async { // blok 1
//    print("B") //2
//
//    //Główny wątek zajęty więc nie wiejdzie do środa dopóki blok 1 nie skończy
//    DispatchQueue.main.async { // blok 2
//        print("C") // 4
//        //Główny wątek zajęty więc nie wiejdzie do środa dopóki blok 2 nie skończy
//        DispatchQueue.main.async { // blok 3
//            print("D") // 5
//        }
//    }
//
//    print("E") // 3 - po wywołaniu tego printa blok 1 kończy więc blok 2 może zacząć
//}


//A B E C D


//print("F") //1

////Odpalamy główny wątek
//DispatchQueue.main.async { // blok 1
//    print("G") //2
//
//    //Główny wątek zajęty więc nie wiejdzie do środa dopóki blok 1 nie skonczy
//    DispatchQueue.main.async { // blok 2
//        print("H") // 5
//        //Główny wątek zajęty więc nie wiejdzie do środa dopóki blok 2 nie skończy
//        DispatchQueue.main.async { // blok 3 - ten zostanie wywołany na koncu bo jako ostatni został dodany do kolejki
//            print("I") // 7
//        }
//    }
//
//    //Odpalamy wątek poboczny więc wolny, wchodzimy do środka
//    //blok 4 wywołany sync wiec blokuje dalsze printy
//    DispatchQueue.global().async { // blok 4
//        print("J") //3 - po wywołaniu tego
//        //znowu próbujemy drukować na wątku głównym, który jest zajęty, więc dodajemy do kolejki
//        DispatchQueue.main.async { // blok 5
//            //blok 5 zostanie wywołany przed 3cim bo został jako pierwszy dodany do kolejki
//            print("K") // 6
//        }
//    }
//
//    print("L") //4 po zakończeniu bloku 4 wywołany zostanie ten print i blok 1 zakończy działanie
//                // dzieki czemu blok 2 będzie mógł zostać wywołany
//}

// F G J L H K I

// w przypadku gdyby blok 4 był async kolejność mogłaby wyglądać tak:

// F G L - bo async nie czeka na blok 4 tylko wraca od razu - H lub J (zależy od maszyny i tego jak GCD zarządzi)
// jeżeli 1 będzie H - blok 2 - to potem wydrukuje I - blok 7
// jeżeli 1 będzie J - blok 4 - to potem wydrukuje K


//Dispatch Group: - uncomment code to see results

var op1Result: Int = 0
var op2Result: Int = 0
var op3Result: Int = 0

//wait:

//moving to global since wait blocks caller thread so shouldn't use on main
//DispatchQueue.global().async {
//
//    let dispatchGroup: DispatchGroup = DispatchGroup()
//
//    //simulate operation 1:
//    dispatchGroup.enter()
//    DispatchQueue.global().async {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
//            op1Result = 7
//            dispatchGroup.leave()
//        }
//    }
//
//    //simulate operation 2:
//    dispatchGroup.enter()
//    DispatchQueue.global().async {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
//            op2Result = 7
//            dispatchGroup.leave()
//        }
//    }
//
//    //simulate operation 3:
//    dispatchGroup.enter()
//    DispatchQueue.global().async {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            op3Result = 7
//            dispatchGroup.leave()
//        }
//    }
//
//    let wait = dispatchGroup.wait(timeout: .distantFuture)
//    print(wait)
//    print(op1Result)
//    print(op2Result)
//    print(op3Result)
//
//}

//notify:

//let dispatchGroup: DispatchGroup = DispatchGroup()
//
////simulate operation 1:
//dispatchGroup.enter()
//DispatchQueue.global().async {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//        op1Result = 1
//        dispatchGroup.leave()
//    }
//}
//
////simulate operation 2:
//dispatchGroup.enter()
//DispatchQueue.global().async {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
//        op2Result = 2
//        dispatchGroup.leave()
//    }
//}
//
////simulate operation 3:
//dispatchGroup.enter()
//DispatchQueue.global().async {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 9.0) {
//        op3Result = 3
//        dispatchGroup.leave()
//    }
//}
//
//dispatchGroup.notify(queue: .main) {
//    print(op1Result)
//    print(op2Result)
//    print(op3Result)
//}


//queue:
//with q you do not use enter or leave, you just pass the group to queue

//let dispatchGroup: DispatchGroup = DispatchGroup()
//let dispatchQ = DispatchQueue(label: "dispatch.q.group", attributes: .concurrent)
//
////simulate operation 1:
//dispatchQ.async(group: dispatchGroup) {
//    (0...5).forEach { print("\($0) $") } // simulates timly operation
//    op1Result = 1
//}
//
////simulate operation 2:
//dispatchQ.async(group: dispatchGroup) {
//    (0...5).forEach { print("\($0) &") } // simulates timly operation
//    op2Result = 2
//}
//
////simulate operation 3:
//dispatchQ.async(group: dispatchGroup) {
//    (0...5).forEach { print("\($0) *") } // simulates timly operation
//    op3Result = 3
//}
//
//dispatchGroup.notify(queue: dispatchQ) {
//    print("did finish")
//    print(op1Result)
//    print(op2Result)
//    print(op3Result)
//}


//blocks:

//
//let dispatchGroup: DispatchGroup = DispatchGroup()
//
//var tasks: [DispatchWorkItem] = [
//    DispatchWorkItem {
//        (0...5).forEach { print("\($0) $") } // simulates timly operation
//        op1Result = 1
//        dispatchGroup.leave()
//    },
//    DispatchWorkItem {
//        (0...5).forEach { print("\($0) &") } // simulates timly operation
//        op2Result = 2
//        dispatchGroup.leave()
//    },
//    DispatchWorkItem {
//        (0...5).forEach { print("\($0) *") } // simulates timly operation
//        op3Result = 3
//        dispatchGroup.leave()
//    }
//]
//
//
//tasks.forEach { task in
//    dispatchGroup.enter()
//    DispatchQueue.main.async(execute: task)
//}
//
//dispatchGroup.notify(queue: .main) {
//    print("did finish")
//    print(op1Result)
//    print(op2Result)
//    print(op3Result)
//}


// blocks with q:

let dispatchGroup: DispatchGroup = DispatchGroup()
let dispatchQ = DispatchQueue(label: "dispatch.q.group", attributes: .concurrent)

var tasks: [DispatchWorkItem] = [
    DispatchWorkItem {
        (0...5).forEach { print("\($0) $") } // simulates timly operation
        op1Result = 1
    },
    DispatchWorkItem {
        (0...5).forEach { print("\($0) &") } // simulates timly operation
        op2Result = 2
    },
    DispatchWorkItem {
        (0...5).forEach { print("\($0) *") } // simulates timly operation
        op3Result = 3
    }
]

tasks.forEach { task in
    dispatchQ.async(group: dispatchGroup, execute: task)
}

// uncomment to see how cancellation works
//tip: you cannot cancel an ongoing task
//tasks[2].cancel()

dispatchGroup.notify(queue: .main) {
    print("did finish")
    print(op1Result)
    print(op2Result)
    print(op3Result)
}
