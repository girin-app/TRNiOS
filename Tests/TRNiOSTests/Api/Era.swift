import XCTest
@testable import TRNiOS

final class TestEra: XCTestCase {
    func testEra() async throws {
        let res = Mortal(period: 80, current: 14068466)
        XCTAssertEqual("2607", res.toU8a().toHexString())
    }
    
    func testEra2() async throws {
        let res = Mortal(period: 80, current: 14138070)
        XCTAssertEqual("6605", res.toU8a().toHexString())
    }
    
    func testEra3() async throws {
        let res = Mortal(period: 80, current: 14138184)
        XCTAssertEqual("8604", res.toU8a().toHexString())
    }
}
