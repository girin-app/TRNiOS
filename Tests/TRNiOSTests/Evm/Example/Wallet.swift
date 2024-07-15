import XCTest
import Web3
import WalletKit
@testable import TRNiOS

final class TestEvmWallet: XCTestCase {
    func testMnemonic() throws {
        
        let mnemonic = "model vanish nest share talk duck promote useful base wrong veteran pink"
        let seed  = try Mnemonic(seedPhrase: mnemonic).seed().get()
        let wallet     = try Wallet(seedData: seed, version: .mainnet(.private))
        
        let account    = try wallet.account(coinType: .ETH, atIndex: 0)
        let a = account[.normal(0)]

        let privateKey = "0x" + a.privateKey.key.dropFirst().toHexString()
        XCTAssertEqual("0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65", privateKey)
        let w = try EthereumPrivateKey(hexPrivateKey: privateKey)
        
        XCTAssertEqual("0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292", w.address.hex(eip55: true))
    }
    
    func testImportPrivatekey() throws {
        let privateKey = "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65"
        let wallet = try EthereumPrivateKey(hexPrivateKey: privateKey)
        XCTAssertEqual("0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292", wallet.address.hex(eip55: true))
        
    }
}
