//
//  MessageDetailsViewController.swift
//  PageObjectExample
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import UIKit

class MessageDetailsViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel! {
        didSet {
            messageLabel.accessibilityIdentifier = "messageLabel"
        }
    }

    private var message: String?

    func setMessage(_ message: String?) {
        self.message = message
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        messageLabel.accessibilityLabel = message
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(hasAppeared)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(hasAppeared)
    }

}
