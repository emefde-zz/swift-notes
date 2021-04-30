import Foundation


class ProdAPIClient {

    func fetchData() {
        print("data fetched")
    }

}

class StageAPIClient {

    func fetchStageData() {
        print("fetch stage data")
    }

}


class ClientCode {

    let client: ProdAPIClient

    init(client: ProdAPIClient) {
        self.client = client
    }

    func fetchData() {
        client.fetchData()
    }

}

let clientCode = ClientCode(client: ProdAPIClient())
clientCode.fetchData()

// wont work
//let clientCode = ClientCode(client: StageAPIClient())
//clientCode.fetchData()

class Adapter: ProdAPIClient {

    let adaptee: StageAPIClient

    init(adaptee: StageAPIClient) {
        self.adaptee = adaptee
    }

    override func fetchData() {
        adaptee.fetchStageData()
    }

}

let clientCodeAdapter = ClientCode(client: Adapter(adaptee: StageAPIClient()))
clientCodeAdapter.fetchData()

// or if you can go with protocols


protocol APIClient {

    func fetchData()

}

class ClientCodeProtocol {

    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    func fetchData() {
        client.fetchData()
    }

}

extension ProdAPIClient: APIClient { }
extension StageAPIClient: APIClient {
    func fetchData() {
        fetchStageData()
    }
}


let clientCodeProtocol = ClientCodeProtocol(client: StageAPIClient())
clientCodeProtocol.fetchData()
