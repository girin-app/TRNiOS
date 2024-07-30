import XCTest
import Web3
@testable import TRNiOS

final class TestBridge: XCTestCase {
    func testBridge() async throws {
        // 0. initialized api
        let api = try Api(chain: .porcini)
        let senderPrivateKey = try EthereumPrivateKey(hexPrivateKey: "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65")
        
        // 1. initial bridge call method
        let destination = EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
        let amount = EthereumQuantity(quantity: BigUInt(1000000))
        let method = MethodWithdrawXrp(args: WithdrawXrpArgs(amount: amount, destination: destination))
        
        
        // 2. create Extrinsic
        // 2.1 nonce
        let nonce = try await api.accountNextIndex(address: senderPrivateKey.address)
        
        // 2.2 era
        let blockHash = try await api.chainGetFinalizedHead()
        let block = try await api.chainGetBlock(hash: blockHash)
        let mortal = Mortal(current: try UInt64(block.header.number.quantity))
        
        let tip = EthereumQuantity(quantity: BigUInt.zero)
        var extrinsic = SubmittableExtrinsic(signature: Signature(era: mortal.toMortalEra(), nonce: try EthereumQuantity(nonce), tip: tip), method: method)
        
        // 3. get sign info
        let runtimeVersion = try await api.stateGetRuntimeVersion(hash: blockHash)
        
        // 4. sign
        try extrinsic.sign(privateKey: senderPrivateKey, runtimeVersion: runtimeVersion, genensisHash: api.genesisHash, blockHash: blockHash)
        
        // 5. broadcast
        let extrinsicHash = try await api.authorSubmitExtrinsic(encodedData: extrinsic.toHex())
        
        print(extrinsicHash)
        XCTAssertEqual(extrinsicHash.bytes.count, 32)
    }
    
    func testBridgeWithFeeProxy() async throws {
        // 0. initialized api
        let api = try Api(chain: .porcini)
        let senderPrivateKey = try EthereumPrivateKey(hexPrivateKey: "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65")
        
        // 1. initial fee proxy bridge call method
        let destination = EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
        let amount = EthereumQuantity(quantity: BigUInt(1000000))
        
        let method = MethodFeeProxy(
            args: FeeProxyArgs(
                paymentAsset: BigUInt(ROOT_ID),
                maxPayment: BigUInt(74708), // TODO: calculate maxPayment
                call: MethodWithdrawXrp(
                    args: WithdrawXrpArgs(
                        amount: amount,
                        destination: destination
                    )
                )
            )
        )
        
        
        // 2. create Extrinsic
        // 2.1 nonce
        let nonce = try await api.accountNextIndex(address: senderPrivateKey.address)
        
        // 2.2 era
        let blockHash = try await api.chainGetFinalizedHead()
        let block = try await api.chainGetBlock(hash: blockHash)
        let mortal = Mortal(current: try UInt64(block.header.number.quantity))
        
        // 2.3 tip
        let tip = EthereumQuantity(quantity: BigUInt.zero)
        var extrinsic = SubmittableExtrinsic(signature: Signature(era: mortal.toMortalEra(), nonce: try EthereumQuantity(nonce), tip: tip), method: method)
        
        // 3. get sign info
        let runtimeVersion = try await api.stateGetRuntimeVersion(hash: blockHash)
        
        // 4. sign
        try extrinsic.sign(privateKey: senderPrivateKey, runtimeVersion: runtimeVersion, genensisHash: api.genesisHash, blockHash: blockHash)
        
        // 5. broadcast
        let extrinsicHash = try await api.authorSubmitExtrinsic(encodedData: extrinsic.toHex())
        
        print(extrinsicHash)
        XCTAssertEqual(extrinsicHash.bytes.count, 32)
    }
}
