import Foundation
import XCTest
import BigInt
@testable import TRNiOS

final class UtilTests: XCTestCase {
    func testbnToU8a0() {
        let res = bnToU8a(bn: BigUInt(0))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("00", hexString)
    }
    
    func testbnToU8a1() {
        let res = bnToU8a(bn: BigUInt(1))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("01", hexString)
    }
    
    func testbnToU8a2() {
        let res = bnToU8a(bn: BigUInt(999))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("e703", hexString)
    }
    
    func testbnToU8a3() {
        let res = bnToU8a(bn: BigUInt(1000000))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("40420f", hexString)
    }
    
    func testbnToU8a4() {
        let res = bnToU8a(bn: BigUInt(1000000), bitLength: 128)
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("40420f00000000000000000000000000", hexString)
    }
    
    func testbnToU8a5() {
        let res = bnToU8a(bn: BigUInt(54), bitLength: 32)
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("36000000", hexString)
    }
    
    func testbnToU8a6() {
        let res = bnToU8a(bn: BigUInt(9), bitLength: 32)
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("09000000", hexString)
    }
    
    func testcompactToU8a1() throws {
        let res = try compactToU8a(BigUInt(65))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("0501", hexString)
    }
    
    func testcompactToU8a2() throws {
        let res = try compactToU8a(BigUInt(16383))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("fdff", hexString)
    }
    
    func testcompactToU8a3() throws {
        let res = try compactToU8a(BigUInt(16386))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("0a000100", hexString)
    }
    
    func testcompactToU8a4() throws {
        let res = try compactToU8a(BigUInt(17386))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("aa0f0100", hexString)
    }
    
    func testcompactToU8a5() throws {
        let res = try compactToU8a(BigUInt(1073741830))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("0306000040", hexString)
    }
    
    func testcompactToU8a6() throws {
        let res = try compactToU8a(BigUInt(51))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("cc", hexString)
    }
    func testcompactToU8a7() throws {
        let res = try compactToU8a(BigUInt(65))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("0501", hexString)
    }
    
    func testcompactToU8a8() throws {
        let res = try compactToU8a(BigUInt(2073741830))
        let hexString = res.map { String(format: "%02x", $0) }.joined()
        print(hexString)
        XCTAssertEqual("0306ca9a7b", hexString)
    }
}
