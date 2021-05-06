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


    func makeRequest(_ url: URL, completion: @escaping (Bool, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(error != nil ? false : true, error)
            }
        }.resume()
    }

}


extension NetworkClient: URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let trust = challenge.protectionSpace.serverTrust,
              SecTrustGetCertificateCount(trust) > 0,
              let certificate = SecTrustGetCertificateAtIndex(trust, 0),
              let local = try? CertificateProvider.fetchCertificate(name: "github.com")
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let data = SecCertificateCopyData(certificate) as Data
        let isValid = CertificateValidator.validate(local: local, against: data, using: trust)
        guard isValid else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        completionHandler(.useCredential, URLCredential(trust: trust))
    }

}
