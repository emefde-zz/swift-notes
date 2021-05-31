//
//  NetworkClient.swift
//  ReactiveApp
//
//  Created by Mateusz Fidos on 31/05/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

enum APIError: Error {
    case invalidBaseURL
    case clientUnavailable
    case failedToCreateUrlRequestFromNetworkRequest
    case other(Error)
    case statusCodeError(statusCode: Int, data: Data?)
}

protocol APIRequest: Encodable {

    associatedtype ResponseType: Decodable

    var path: String { get }

    func urlRequest(baseURL: URL) throws -> URLRequest
    func createResponse(with data: Data?) throws -> ResponseType
}


extension APIRequest {

    func urlRequest(baseURL: URL) throws -> URLRequest {
        ///some complicated structuring code like:
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw APIError.failedToCreateUrlRequestFromNetworkRequest
        }

        components.path = path.first == "/" ? path : "/\(path)"

        guard let result = components.url else {
            throw APIError.failedToCreateUrlRequestFromNetworkRequest
        }

        return URLRequest(url: result)
    }

}


protocol APIResponse {

}


final class NetworkClient: NSObject {

    private let validStatusCodes = 200 ..< 300
    private let baseURL: URL
    private let session: URLSession


    init(baseURL: URL = URL(string: "https://my.api/")!,
         session: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
        super.init()
    }


    func send<T: APIRequest>(_ request: T) -> Observable<T.ResponseType> {
        Observable<T.ResponseType>.create { [weak self] observer in
            guard let self = self
            else {
                observer.onError(APIError.clientUnavailable)
                return Disposables.create()
            }

            let urlRequest: URLRequest
            do {
                urlRequest = try request.urlRequest(baseURL: self.baseURL)
            } catch {
                observer.onError(error)
                return Disposables.create()
            }

            return self.session
                .rx
                .response(request: urlRequest)
                .subscribe { response, data in
                    guard self.validStatusCodes.contains(response.statusCode)
                    else {
                        observer.onError(
                            APIError.statusCodeError(
                                statusCode: response.statusCode,
                                data: data
                            )
                        )
                        return
                    }

                    let networkResponse: T.ResponseType
                    do {
                        networkResponse = try request.createResponse(with: data)
                    } catch {
                        observer.onError(error)
                        return
                    }

                    observer.onNext(networkResponse)
                    observer.onCompleted()
            } onError: {
                observer.onError($0)
            } onCompleted: {} onDisposed: {}
        }
    }

}
