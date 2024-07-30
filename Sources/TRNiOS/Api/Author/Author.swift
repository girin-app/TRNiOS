import Foundation
import Web3
import Alamofire

struct AuthorSubmitExtrinsicResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: EthereumData?
}

extension Api {
    public func authorSubmitExtrinsic(encodedData: String) async throws -> EthereumData {
        let params = JSONRpcRequset(method: RpcMethod.AuthorSubmitExtrinsic, params: [encodedData])
        
        let req = AF.request(self.url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
        
        
        let res = await req.serializingDecodable(AuthorSubmitExtrinsicResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let hash = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid extrinsic"])
            }
            
           
            return hash
        case .failure(let err):
            throw err
        }
    }
}

