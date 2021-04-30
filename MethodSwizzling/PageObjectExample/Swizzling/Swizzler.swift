//
//  Swizzler.swift
//  PageObjectExample
//
//  Created by Mateusz Fidos on 21/04/2021.
//

import Foundation

enum Swizzler {

    static func swizzle(aClass: AnyClass, from: Selector, to: Selector) {
        let aClass: AnyClass = aClass
        let originalMethod = class_getInstanceMethod(aClass, from)
        let swizzledMethod = class_getInstanceMethod(aClass, to)

        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            let didAddMethod = class_addMethod(
                aClass,
                from,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod)
            )

            if didAddMethod {
                class_replaceMethod(
                    aClass,
                    to,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod)
                )
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        } else {
            fatalError("Swizzling failed - this is required for UIKit tests")
        }
    }

}
