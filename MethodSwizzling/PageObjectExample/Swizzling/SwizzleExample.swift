//
//  SwizzleExample.swift
//  PageObjectExample
//
//  Created by Mateusz Fidos on 21/04/2021.
//

import Foundation
import UIKit

//for more details see:
//https://nshipster.com/swift-objc-runtime/#method-swizzling
//https://pspdfkit.com/blog/2019/swizzling-in-swift/#swizzling-a-better-way

extension UIViewController {

    private enum AssociatedKeys {
        static var ObjectHandle = false
    }

    static let swizzleAppearanceMethods: Void = {
        Swizzler.swizzle(
            aClass: UIViewController.self,
            from: #selector(viewDidAppear(_:)),
            to: #selector(pageObject_viewDidAppear(_:))
        )
        Swizzler.swizzle(
            aClass: UIViewController.self,
            from: #selector(viewDidDisappear(_:)),
            to: #selector(pageObject_viewDidDisappear(_:))
        )
    }()

    var hasAppeared: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.ObjectHandle) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.ObjectHandle,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }


    @objc fileprivate func pageObject_viewDidAppear(_ animated: Bool) {
        hasAppeared = true
        pageObject_viewDidAppear(animated)
    }


    @objc fileprivate func pageObject_viewDidDisappear(_ animated: Bool) {
        hasAppeared = false
        pageObject_viewDidDisappear(animated)
    }

}
