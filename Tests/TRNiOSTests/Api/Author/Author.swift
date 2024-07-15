import XCTest
import Web3
import BigInt
@testable import TRNiOS

final class TestAuthor: XCTestCase {
    func testSubmittableExtrinsic() async throws {
        let signer = EthereumAddress(hexString: "0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292")!
        let signature = try EthereumData(Data(hex: "b25593b528be5d02feca601b9c71416f7d32eddbd89a4e5ba4e0c20931f4993852d786d5ff70615218ede9ee1605692bca3311d89a1d55a9c88f7d0f9978bfd400"))
        let mortalEra = MortalEra(mortalEra: Data(hex: "7605"))
        let nonce = EthereumQuantity(quantity: BigUInt(51))
        let tip = EthereumQuantity(quantity: BigUInt(0))
        
        let callIndexData = Data(hex: "1203")
        let callIndex = try EthereumData(callIndexData)
        
        let destination = EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
        
        let extrinsic = SubmittableExtrinsic(signature: Signature(signer: signer, signature: signature, era: mortalEra, nonce: nonce, tip: tip), method: try Method(callIndex: callIndex, args: WithdrawXrpArgs(amount: 1000000, destination: destination)))
        
        
        XCTAssertEqual("0x01028455d77a60fd951117f531d2277a5bb4afbe3fb292b25593b528be5d02feca601b9c71416f7d32eddbd89a4e5ba4e0c20931f4993852d786d5ff70615218ede9ee1605692bca3311d89a1d55a9c88f7d0f9978bfd4007605cc00120340420f0000000000000000000000000072ee785458b89d5ec64bec8410c958602e6f7673", try extrinsic.toHex())
    }
    
    func testSign() throws {
        let callIndexData = Data(hex: "1203")
        let callIndex = try EthereumData(callIndexData)
        
        let destination = EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
        
        let method = try Method(callIndex: callIndex, args: WithdrawXrpArgs(amount: 1000000, destination: destination))
        
        let mortalEra = MortalEra(mortalEra: Data(hex: "1603"))
        let nonce = EthereumQuantity(quantity: BigUInt(52))
        let tip = EthereumQuantity(quantity: BigUInt(0))
        
        var extrinsic = method.createExtrinsic(nonce: nonce, era: mortalEra, tip: tip)
        
        let runtimeVersion = RuntimeVersion(specName: "root", implName: "root", authoringVersion: 1, specVersion: 54, implVersion: 0, apis: [[:]], transactionVersion: 9, stateVersion: 0)
        let genesisHash = try EthereumData(Data(hex: "83959f7f4262762f7599c2fa48b418b7e102f92c81fab9e6ef22ab379abdb72f"))
        let blockHash = try EthereumData(Data(hex: "229c525b91f1b6b29c56d57697ba8df4bf4fa6d15aee295e0d611a85f53dde31"))
        
        let privateKey = "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65"
        let wallet = try EthereumPrivateKey(hexPrivateKey: privateKey)
        
        try extrinsic.sign(privateKey: wallet, runtimeVersion: runtimeVersion, genensisHash: genesisHash, blockHash: blockHash)
        XCTAssertEqual("0xb25593b528be5d02feca601b9c71416f7d32eddbd89a4e5ba4e0c20931f4993852d786d5ff70615218ede9ee1605692bca3311d89a1d55a9c88f7d0f9978bfd400", extrinsic.signature.signature?.hex())
        XCTAssertEqual("0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292", extrinsic.signature.signer?.hex(eip55: true))
    }
    
    func testPayload() async throws {
        let callIndexData = Data(hex: "1203")
        let callIndex = try EthereumData(callIndexData)
        
        let destination = EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
        
        let method = try Method(callIndex: callIndex, args: WithdrawXrpArgs(amount: 1000000, destination: destination))
        
        let mortalEra = MortalEra(mortalEra: Data(hex: "1603"))
        let nonce = EthereumQuantity(quantity: BigUInt(52))
        let tip = EthereumQuantity(quantity: BigUInt(0))
        
        let extrinsic = method.createExtrinsic(nonce: nonce, era: mortalEra, tip: tip)
        
        let runtimeVersion = RuntimeVersion(specName: "root", implName: "root", authoringVersion: 1, specVersion: 54, implVersion: 0, apis: [[:]], transactionVersion: 9, stateVersion: 0)
        let genesisHash = try EthereumData(Data(hex: "83959f7f4262762f7599c2fa48b418b7e102f92c81fab9e6ef22ab379abdb72f"))
        let blockHash = try EthereumData(Data(hex: "229c525b91f1b6b29c56d57697ba8df4bf4fa6d15aee295e0d611a85f53dde31"))
        
        let payload = try extrinsic.getPayload(runtimeVersion: runtimeVersion, genensisHash: genesisHash, blockHash: blockHash)
        
        
        XCTAssertEqual("120340420f0000000000000000000000000072ee785458b89d5ec64bec8410c958602e6f76731603d000360000000900000083959f7f4262762f7599c2fa48b418b7e102f92c81fab9e6ef22ab379abdb72f229c525b91f1b6b29c56d57697ba8df4bf4fa6d15aee295e0d611a85f53dde31", payload.hexString)
    }
}
