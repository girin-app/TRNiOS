import Foundation
import Web3
import BigInt

public enum NetworkName: String {
    case root
    case porcini
}

public typealias HttpProviderUrl = String

public func getPublicProviderUrl(network: NetworkName) -> HttpProviderUrl {
    switch network {
    case .root:
        return "https://root.rootnet.live/archive"
    case .porcini:
        return "https://porcini.rootnet.app/archive"
    default:
        fatalError("Unrecognized network name: \(network.rawValue)")
    }
}

public func getWeb3Provider(url: String, networkName: NetworkName) -> Web3HttpProvider {
    return Web3HttpProvider(rpcURL: url)
}
