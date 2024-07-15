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

struct SubmittableExtrinsic: Codable {
    var signature: Signature
    var method: Method
    
    mutating func sign(privateKey: EthereumPrivateKey, runtimeVersion: RuntimeVersion, genensisHash: EthereumData, blockHash: EthereumData) throws {
        let payload = try getPayload(runtimeVersion: runtimeVersion, genensisHash: genensisHash, blockHash: blockHash)
        let sig = try privateKey.sign(message: payload)
        
        signature.signature = try EthereumData(Data(sig.r + sig.s + [UInt8(sig.v)]))
        signature.signer = privateKey.address
    }
    
    func getPayload(runtimeVersion: RuntimeVersion, genensisHash: EthereumData, blockHash: EthereumData) throws -> [UInt8] {
        var payload:[UInt8] = method.callIndex.bytes
        payload += bnToU8a(bn: method.args.amount.quantity, bitLength: 128)
        payload += method.args.destination.rawAddress
        payload += signature.era.mortalEra.bytes
        payload += try compactToU8a(signature.nonce.quantity)
        payload += bnToU8a(bn: signature.tip.quantity)
        payload += bnToU8a(bn: try BigUInt(runtimeVersion.specVersion), bitLength: 32)
        payload += bnToU8a(bn: try BigUInt(runtimeVersion.transactionVersion), bitLength: 32)
        payload += genensisHash.bytes
        payload += blockHash.bytes
        
        return payload
    }
    
    func toU8a() throws -> [UInt8] {
        var u8a:[UInt8] = [132] // version 4 signed(128)
        
        guard let signer = signature.signer else {
            throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "empty signer"])
        }
        u8a += signer.rawAddress
        
        guard let sig = signature.signature else {
            throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "empty signature"])
        }
        u8a += sig.bytes
        
        u8a += signature.era.mortalEra.bytes
        u8a += try compactToU8a(signature.nonce.quantity)
        u8a += bnToU8a(bn: signature.tip.quantity)
        u8a += method.callIndex.bytes
        u8a += bnToU8a(bn: method.args.amount.quantity, bitLength: 128)
        u8a += method.args.destination.rawAddress
        
        let count = try compactToU8a(BigUInt(u8a.count))
        
        
        return count + u8a
    }
    
    func toHex() throws -> String {
        let u8aHex = try self.toU8a().toHexString()
        return "0x" + u8aHex
    }
}

struct Signature: Codable {
    var signer: EthereumAddress?
    var signature: EthereumData?
    var era: MortalEra
    var nonce: EthereumQuantity
    var tip: EthereumQuantity
}

struct MortalEra: Codable {
    var mortalEra: Data
}

struct Method: Codable {
    var callIndex: EthereumData
    var args: WithdrawXrpArgs
    
    init(callIndex: EthereumData = try! EthereumData(Data(hex: "1203")), args: WithdrawXrpArgs) throws {
        self.callIndex = callIndex
        self.args = args
    }
    
    func createExtrinsic(nonce: EthereumQuantity, era: MortalEra, tip: EthereumQuantity) -> SubmittableExtrinsic {
        return SubmittableExtrinsic(
            signature: Signature(signer: nil, signature: nil, era: era, nonce: nonce, tip: tip),
            method: self)
    }
}

struct WithdrawXrpArgs: Codable {
    var amount: EthereumQuantity
    var destination: EthereumAddress
}
