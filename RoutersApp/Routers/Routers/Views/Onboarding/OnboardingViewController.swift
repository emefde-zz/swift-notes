//
//  ViewController.swift
//  Routers
//
//  Created by Mateusz Fidos on 17/05/2021.
//

import UIKit

class OnboardingViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Views.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.signInButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()


    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.signUpButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()


    let interactor: OnboardingInteractor


    init(interactor: OnboardingInteractor) {
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
        stackView.addArrangedSubview(signInButton)
        stackView.addArrangedSubview(signUpButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    @objc private func signIn() {
        interactor.signIn()
    }


    @objc private func signUp() {
        interactor.signUp()
    }


}

extension OnboardingViewController {

    fileprivate enum Constants {
        enum Strings {
            static let signInButtonTitle: String = "Sign In"
            static let signUpButtonTitle: String = "Sign Up"
        }
        enum Views {
            static let stackViewSpacing: CGFloat = 24.0
        }
    }

}
