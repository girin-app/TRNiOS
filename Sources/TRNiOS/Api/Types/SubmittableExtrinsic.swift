import Foundation
import BigInt
import Web3

struct SubmittableExtrinsic {
    var signature: Signature
    var method: Method
    
    mutating func sign(privateKey: EthereumPrivateKey, runtimeVersion: RuntimeVersion, genensisHash: EthereumData, blockHash: EthereumData) throws {
        let payload = try getPayload(runtimeVersion: runtimeVersion, genensisHash: genensisHash, blockHash: blockHash)
        let sig = try privateKey.sign(message: payload)

        signature.signature = try EthereumData(Data(sig.r + sig.s + [UInt8(sig.v + 27)]))
        signature.signer = privateKey.address
    }
    
    func getPayload(runtimeVersion: RuntimeVersion, genensisHash: EthereumData, blockHash: EthereumData) throws -> [UInt8] {
        var payload: [UInt8] = method.toU8a()
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
        
        u8a += try signature.toU8a()
        u8a += method.toU8a()
        
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
    
    func toU8a() throws -> [UInt8] {
        guard let signer = signer else {
            throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "empty signer"])
        }
        var u8a: [UInt8] = signer.rawAddress
        
        guard let sig = signature else {
            throw NSError(domain: "api", code: 0, userInfo: [NSLocalizedDescriptionKey: "empty signature"])
        }
        u8a += sig.bytes
        
        u8a += era.mortalEra.bytes
        u8a += try compactToU8a(nonce.quantity)
        u8a += bnToU8a(bn: tip.quantity)
        
        return u8a
    }
}

struct MortalEra: Codable {
    var mortalEra: Data
}
