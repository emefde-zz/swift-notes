//
//  SignInViewController.swift
//  Routers
//
//  Created by Mateusz Fidos on 19/05/2021.
//

import UIKit


final class SignInViewController: UIViewController {

    private lazy var beginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.Strings.beginButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(begin), for: .touchUpInside)
        return button
    }()

    let interactor: SignInInteractor


    init(interactor: SignInInteractor) {
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
        view.addSubview(beginButton)
        NSLayoutConstraint.activate([
            beginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            beginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    @objc private func begin() {
        interactor.begin()
    }

}


extension SignInViewController {

    fileprivate enum Constants {
        enum Strings {
            static let beginButtonTitle: String = "Begin sign in process"
        }
    }

}
