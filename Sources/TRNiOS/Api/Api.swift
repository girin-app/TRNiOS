import Foundation

import Web3

public enum Chain {
    case root, porcini
}

public class Api {
    let url: URL
    let genesisHash: EthereumData
    public init(chain: Chain) throws {
        switch(chain) {
        case .root:
            url = URL(string: "https://root.rootnet.live")!
            genesisHash = try EthereumData(Data(hex: "046e7cb5cdfee1b96e7bd59e051f80aeba61b030ce8c9275446e0209704fd338"))
        case .porcini:
            url = URL(string: "https://porcini.rootnet.app")!
            genesisHash = try EthereumData(Data(hex: "83959f7f4262762f7599c2fa48b418b7e102f92c81fab9e6ef22ab379abdb72f"))
        }
    }
    
}

enum RpcMethod: String, Codable {
    // account
    case AccountNextIndex = "account_nextIndex"
    
    // chain
    case ChainGetBlock = "chain_getBlock"
    case ChainGetFinalizedHead = "chain_getFinalizedHead"
    case ChainGetBlockHash = "chain_getBlockHash"
    
    // author
    case AuthorSubmitExtrinsic = "author_submitExtrinsic"
    
    // state
    case StateGetRuntimeVersion = "state_getRuntimeVersion"
}

struct JSONRpcRequset: Codable {
    var id: UInt16 = UInt16.random(in: 1...UInt16.max)
    var jsonrpc: String = "2.0"
    var method: RpcMethod
    var params: [String]
}

struct JsonRpcError: Codable {
    var code: Int
    var message: String
}

protocol JSONRpcResponse: Codable {
    var id: UInt16?             { get set}
    var jsonrpc: String?        { get set}
    var error: JsonRpcError?    { get set}
}


