import Foundation
import Web3
import Alamofire
import BigInt

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

struct StateCallResponse: JSONRpcResponse, Codable {
    var id: UInt16?
    var jsonrpc: String?
    var error: JsonRpcError?
    var result: EthereumData?
}

struct Weight {
    var refTime: BigUInt
    var proofSize: BigUInt
}

public struct RuntimeDispatchInfo {
    var weight: Weight
    var `class`: Int
    var partialFee: BigUInt
    
    init(src: Data) throws {
        let data = src.bytes
        let (offset1, refTime) = decodeCompact(u8a: data)
        let (offset2, proofSize) = decodeCompact(u8a: Array(data[offset1..<data.count]))
        let classValue = Int(data[offset1 + offset2])
        let a: [UInt8] = data[offset1 + offset2 + 1..<data.count].reversed()
        let partialFee = BigUInt(a)

        self.weight = Weight(refTime: refTime, proofSize: proofSize)
        self.class = classValue
        self.partialFee = partialFee
    }
}

enum StateCallQuery: String, Codable {
    case TransactionPaymentApiQueryInfo = "TransactionPaymentApi_query_info"
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
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error StateGetRuntimeVersion"])
            }
            return runtimeVersion
        case .failure(let err):
            throw err
        }
    }
    
    public func stateCallTransactionPayment(extrinsic: SubmittableExtrinsic) async throws -> RuntimeDispatchInfo {
        let extrinsicU8a = try extrinsic.toU8a()
        let extrinsicSizeU8a = bnToU8a(bn: BigUInt(extrinsicU8a.count), bitLength: 32)
        let encodedParam = u8aConcatStrict(u8as: [extrinsicU8a, extrinsicSizeU8a])
        let queryParams = [StateCallQuery.TransactionPaymentApiQueryInfo.rawValue, encodedParam.toHexString()]
        
        let params = JSONRpcRequset(method: RpcMethod.StateCall, params: queryParams)
        
        let req = AF.request(self.url, method: .post, parameters: params, encoder: JSONParameterEncoder.default)
        
        let res = await req.serializingDecodable(StateCallResponse.self).result
        switch res {
        case .success(let r):
            if r.error != nil {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: r.error])
            }
            guard let encodedDispatchInfo = r.result else {
                throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid runtime dispatch info"])
            }
            
            return try RuntimeDispatchInfo(src: Data(encodedDispatchInfo.makeBytes()))
        case .failure(let err):
            throw err
        }
    }
}
