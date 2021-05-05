//
//  CertificateValidator.swift
//  SSLTSLExample
//
//  Created by Mateusz Fidos on 05/05/2021.
//

import Foundation
import Security


enum CertificateValidator {

    enum CertificateProviderError: Error {
        case invalidResource
    }


    static func validate(
        local: Certificate,
        against data: Data,
        using secTrust: SecTrust
    ) -> Bool {
        SecTrustSetAnchorCertificates(secTrust, [local.certificate] as CFArray)
        return SecTrustEvaluateWithError(secTrust, nil) && local.data == data
    }

}
