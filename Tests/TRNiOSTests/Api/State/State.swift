import XCTest
import Web3
import BigInt
@testable import TRNiOS

final class TestState: XCTestCase {
    func testStateGetRuntimeVersion() async throws {
        let api = try Api(chain: .porcini)
        
        let hash = try await api.chainGetFinalizedHead()
        
        let runtimeVersion = try await api.stateGetRuntimeVersion(hash:hash)
        
        XCTAssertEqual(runtimeVersion.specName, "root")
        XCTAssertEqual(runtimeVersion.implName, "root")
        XCTAssertEqual(runtimeVersion.authoringVersion, 1)
        XCTAssertEqual(runtimeVersion.specVersion, 55)
        XCTAssertEqual(runtimeVersion.implVersion, 0)
        XCTAssertEqual(runtimeVersion.transactionVersion, 10)
        XCTAssertEqual(runtimeVersion.stateVersion, 0)
        XCTAssertEqual(runtimeVersion.apis.count, 17)
    }

    func testStateCall() async throws {
        let api = try Api(chain: .porcini)

        let extrinsic = SubmittableExtrinsic(
            signature: Signature(
                signer: EthereumAddress(hexString: "0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292")!,
                era: MortalEra(mortalEra: Data(hex: "2603")),
                nonce: EthereumQuantity(quantity: BigUInt(83)),
                tip: EthereumQuantity(quantity: BigUInt.zero)
            ),
            method: MethodFeeProxy(
                args: FeeProxyArgs(
                    paymentAsset: BigUInt(1),
                    maxPayment: BigUInt.zero,
                    call: MethodWithdrawXrp(
                        args: WithdrawXrpArgs(
                            amount: EthereumQuantity(quantity: BigUInt("1000000")),
                            destination: EthereumAddress(hexString: "0x72ee785458b89d5ec64bec8410c958602e6f7673")!
                        )
                    )
                )
            )
        )

        let runtimeDispatchInfo = try await api.stateCallTransactionPayment(extrinsic: extrinsic)
        XCTAssertEqual(runtimeDispatchInfo.weight.refTime, BigUInt("1285926000"))
        XCTAssertEqual(runtimeDispatchInfo.weight.proofSize, BigUInt("13627"))
        XCTAssertEqual(runtimeDispatchInfo.`class`, 1)
        XCTAssertEqual(runtimeDispatchInfo.partialFee, BigUInt("65991"))
    }

    func testDecodeU8aRuntimeDispatchInfo() {
        let u8a = Data(hex: "0370aca54cedd401c7010100000000000000000000000000")
        let runtimeDispatchInfo = try! RuntimeDispatchInfo(src: u8a)

        XCTAssertEqual(runtimeDispatchInfo.weight.refTime, BigUInt("1285926000"))
        XCTAssertEqual(runtimeDispatchInfo.weight.proofSize, BigUInt("13627"))
        XCTAssertEqual(runtimeDispatchInfo.`class`, 1)
        XCTAssertEqual(runtimeDispatchInfo.partialFee, BigUInt("65991"))
    }
}
