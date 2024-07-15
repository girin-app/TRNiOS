import Foundation
import Web3
import Alamofire

struct AccountNextIndexResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: UInt64?
}

extension Api {
    public func accountNextIndex(address: EthereumAddress) async throws -> UInt64 {
        let params = JSONRpcRequset(method: RpcMethod.AccountNextIndex, params: [address.hex(eip55: true)])
        
        let req = AF.request(self.url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
        
        
        let res = await req.serializingDecodable(AccountNextIndexResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let nonce = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid nonce"])
            }
            return nonce
        case .failure(let err):
            throw err
        }
    }
}
