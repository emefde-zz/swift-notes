//
//  MessageViewControllerSwizzle.swift
//  PageObjectExample
//
//  Created by Mateusz Fidos on 21/04/2021.
//

import Foundation
import UIKit

extension MessageViewController {

    static let swizzleMessageValidation: Void = {
        Swizzler.swizzle(
            aClass: MessageViewController.self,
            from: #selector(validateMessage),
            to: #selector(pageObject_validateMessage)
        )
    }()


    @objc func pageObject_validateMessage() {
        print("I'm swizzled")
        pageObject_validateMessage()//comment this part out and call won't be passed further down the responder chain to original caller
    }

}
