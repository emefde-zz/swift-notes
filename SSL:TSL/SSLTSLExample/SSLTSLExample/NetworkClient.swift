//
//  NetworkClient.swift
//  SSLTSLExample
//
//  Created by Mateusz Fidos on 05/05/2021.
//

import Foundation


final class NetworkClient: NSObject {

    private lazy var session: URLSession = {
        URLSession(configuration: .ephemeral, delegate: self, delegateQueue: .main)
    }()


    func makeRequest(_ url: URL, completion: @escaping (String) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion("wazzup")
            }
        }
    }

}


extension NetworkClient: URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {

    }

}
