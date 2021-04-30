//
//  ViewController.swift
//  PageObjectExample
//
//  Created by Mateusz Fidos on 18/04/2021.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.accessibilityIdentifier = "titleLabel"
        }
    }

    @IBOutlet var messageTextField: UITextField! {
        didSet {
            messageTextField.accessibilityIdentifier = "messageTextField"
            messageTextField.accessibilityLabel = "Write something here"
            messageTextField.addTarget(
                self,
                action: #selector(textFieldDidChange),
                for: .editingChanged
            )
        }
    }

    @IBOutlet var sendButton: UIButton! {
        didSet {
            sendButton.accessibilityIdentifier = "sendButton"
            sendButton.isEnabled = messageTextField.hasText
            sendButton.addTarget(self, action: #selector(validateMessage), for: .touchUpInside)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(hasAppeared) // swizzled property here
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(hasAppeared)
    }

    private lazy var alertController: UIAlertController = {
        let alert = UIAlertController(
            title: nil,
            message: "Message cannot be longer than 50 characters",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()


    @objc func validateMessage() {
        guard let message = messageTextField.text,
              !message.isEmpty,
              message.count <= 50
        else {
            showAlert()
            return
        }

        showMessageDetails(message)
    }


    private func showAlert() {
        present(alertController, animated: true, completion: nil)
    }


    private func showMessageDetails(_ message: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MessageDetailsViewController = storyboard.instantiateViewController(
            identifier: "messageDetailsViewController"
        )
        viewController.setMessage(message)

        present(viewController, animated: true, completion: nil)
    }


    @objc private func textFieldDidChange() {
        sendButton.isEnabled = messageTextField.hasText
    }

}
