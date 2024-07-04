import Foundation
import Web3
import BigInt

enum NetworkName: String {
    case root
    case porcini
}

typealias HttpProviderUrl = String

func getPublicProviderUrl(network: NetworkName) -> HttpProviderUrl {
    switch network {
    case .root:
        return "https://root.rootnet.live/archive"
    case .porcini:
        return "https://porcini.rootnet.app/archive"
    default:
        fatalError("Unrecognized network name: \(network.rawValue)")
    }
}

func getWeb3Provider(url: String, networkName: NetworkName) -> Web3HttpProvider {
    return Web3HttpProvider(rpcURL: url)
}
