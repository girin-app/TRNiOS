import XCTest
import Web3
@testable import TRNiOS

final class TestAccount: XCTestCase {
    func testAccountNextIndex() async throws {
        let api = try Api(chain: .porcini)
        
        let address = EthereumAddress(hexString: "0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292")!
        let nonce = try await api.accountNextIndex(address: address)
        
        XCTAssertGreaterThan(nonce, 0)
    }
}
