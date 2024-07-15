import Foundation
import Alamofire
import Web3

struct ChainGetBlockResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: BlockResult?
}

struct ChainBlockHashResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: EthereumData?
}

struct BlockResult: Codable {
    var block: Block
}

public struct Block: Codable {
    var header: Header
    var extrinsics: [EthereumData]
}

struct Header: Codable {
    var parentHash: EthereumData
    var number: EthereumQuantity
    var stateRoot: EthereumData
    var extrinsicsRoot: EthereumData
    var digest: Log
}

struct Log: Codable {
    var logs: [EthereumData]
}



extension Api {
    public func chainGetBlock(hash: EthereumData) async throws -> Block {
        let params = JSONRpcRequset(method: RpcMethod.ChainGetBlock, params: [hash.hex()])

        let req = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)


        let res = await req.serializingDecodable(ChainGetBlockResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let block = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid block"])
            }
            return block.block
        case .failure(let err):
            throw err
        }
    }
    
    public func chainGetBlockHash() async throws -> EthereumData {
        let params = JSONRpcRequset(id: 1, jsonrpc: "2.0", method: RpcMethod.ChainGetBlockHash, params: [])

        let req = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)


        let res = await req.serializingDecodable(ChainBlockHashResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let hash = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid blockhash"])
            }
            return hash
        case .failure(let err):
            throw err
        }

    }
    
    public func chainGetFinalizedHead() async throws -> EthereumData {
        let params = JSONRpcRequset(id: 1, jsonrpc: "2.0", method: RpcMethod.ChainGetFinalizedHead, params: [])

        let req = AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)


        let res = await req.serializingDecodable(ChainBlockHashResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
           
            guard let hash = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid blockhash"])
            }
            return hash
        case .failure(let err):
            throw err
        }

    }
}
