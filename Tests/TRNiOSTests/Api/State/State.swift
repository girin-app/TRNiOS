import XCTest
import Web3
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
}
