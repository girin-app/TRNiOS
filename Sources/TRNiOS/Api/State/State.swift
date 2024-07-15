import Foundation
import Web3
import Alamofire

struct StateGetRuntimeVersionResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: RuntimeVersion?
}

public struct RuntimeVersion: Codable {
    var specName: String
    var implName: String
    var authoringVersion: UInt64
    var specVersion: UInt64
    var implVersion: UInt64
    var apis: [[EthereumData: UInt64]]
    var transactionVersion: UInt64
    var stateVersion: UInt64
}


extension Api {
    public func stateGetRuntimeVersion(hash: EthereumData) async throws -> RuntimeVersion {
        let params = JSONRpcRequset(method: RpcMethod.StateGetRuntimeVersion, params: [hash.hex()])
        
        let req = AF.request(self.url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
        
        
        let res = await req.serializingDecodable(StateGetRuntimeVersionResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let runtimeVersion = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid nonce"])
            }
            return runtimeVersion
        case .failure(let err):
            throw err
        }
    }
}
