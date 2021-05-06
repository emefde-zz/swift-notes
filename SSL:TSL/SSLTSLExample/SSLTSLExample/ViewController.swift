//
//  ViewController.swift
//  SSLTSLExample
//
//  Created by Mateusz Fidos on 05/05/2021.
//

import UIKit

class ViewController: UIViewController {

    private let client = NetworkClient()


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url = URL(string: "https://github.com")
        else {
            return
        }

        client.makeRequest(url) { [weak self] (result, error) in
            let message = result ? "Success" : "Failure"
            let alert = UIAlertController(title: "SSLPinning", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }

    }


}

