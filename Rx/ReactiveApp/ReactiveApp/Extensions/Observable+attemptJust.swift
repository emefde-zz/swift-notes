//
//  Observable+attemptJust.swift
//  ReactiveApp
//
//  Created by Mateusz Fidos on 31/05/2021.
//

import RxSwift


extension Observable {

    static func attemptJust<T>(_ f: @escaping () throws -> T) -> Observable<T> {
        Observable<T>.create { observer -> Disposable in
            do {
                observer.on(.next(try f()))
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create()
        }
    }

}
