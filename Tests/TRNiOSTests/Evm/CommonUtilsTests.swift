import XCTest
@testable import TRNiOS

final class CommonUtilsTests: XCTestCase {
    
    func testAssetIdToERC20Address() {
        XCTAssertEqual(try assetIdToERC20Address(assetId: 1).hex(eip55: true), "0xcCcCCccC00000001000000000000000000000000")
    }
    
    func testCollectionIdToERC721Address() {
        XCTAssertEqual(try collectionIdToERC721Address(collectionId: 1).hex(eip55: true), "0xaAAaAaaa00000001000000000000000000000000")
    }
    
    func testCollectionIdToERC1155Address() {
        XCTAssertEqual(try collectionIdToERC1155Address(collectionId: 1).hex(eip55: true), "0xBBBBBbbB00000001000000000000000000000000")
    }
    
}
