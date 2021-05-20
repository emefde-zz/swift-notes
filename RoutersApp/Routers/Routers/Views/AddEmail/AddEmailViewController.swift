//
//  AddEmailViewController.swift
//  Routers
//
//  Created by Mateusz Fidos on 20/05/2021.
//

import UIKit


final class AddEmailViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Views.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var addEmailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Strings.textFieldPlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.Strings.submitButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()

    let interactor: AddEmailInteractor


    init(interactor: AddEmailInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUpViews()
    }


    private func setUpViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(addEmailTextField)
        stackView.addArrangedSubview(submitButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    @objc private func submit() {
        interactor.submit(email: addEmailTextField.text)
    }

}


extension AddEmailViewController {

    fileprivate enum Constants {
        enum Views {
            static let stackViewSpacing: CGFloat = 24.0
        }
        enum Strings {
            static let textFieldPlaceholder: String = "Type your email here"
            static let submitButtonTitle: String = "Submit"
        }
    }

}
