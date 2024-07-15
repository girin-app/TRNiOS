import XCTest
import Web3
@testable import TRNiOS

final class TestChain: XCTestCase {
    func testChainGetBlock() async throws {
        let api = try Api(chain: .porcini)
        
        let block = try await api.chainGetBlock(hash: EthereumData(Data(hexString: "8285aac7457e68c44e893402efc582c862eb37667a54529778c683ed70b6dc1a")))
        
        XCTAssertEqual(block.header.number.quantity, BigUInt(14087392))
    }
    
    func testChainGetFinalizedHead() async throws {
        let api = try Api(chain: .porcini)
        
        let hash = try await api.chainGetFinalizedHead()
        
        XCTAssertEqual(hash.bytes.count, 32)
    }
}
