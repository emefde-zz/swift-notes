//
//  CertificateProvider.swift
//  SSLTSLExample
//
//  Created by Mateusz Fidos on 05/05/2021.
//

import Foundation


enum CertificateProvider {

    enum CertificateProviderError: Error {
        case invalidResource
    }


    static func fetchCertificate(
        name: String,
        bundle: Bundle = .main
    ) throws -> Certificate {
        guard let url = bundle.url(forResource: name, withExtension: "cer"),
              let data = try? Data(contentsOf: url),
              let cert = SecCertificateCreateWithData(nil, data as CFData)
        else {
            throw CertificateProviderError.invalidResource
        }

        return Certificate(certificate: cert, data: data)
    }

}
