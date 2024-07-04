import XCTest
import Web3
import Web3ContractABI
import Web3PromiseKit
import BigInt

@testable import TRNiOS

final class Balance: XCTestCase {
    
    // native - XRP
    func testNativeBalance() async throws {    
        let url = getPublicProviderUrl(network: NetworkName.porcini)
        let provider = getWeb3Provider(url: url, networkName: NetworkName.porcini)
        let web3 = Web3(provider: provider)
        
        let address = EthereumAddress(hexString: "0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292")!
        
        let balance = try web3.eth.getBalance(address: address, block: .latest).wait()
        print(balance)
        XCTAssertGreaterThanOrEqual(balance.quantity, BigUInt.zero)
    }

    func testErc20Balance() async throws {
        let url = getPublicProviderUrl(network: NetworkName.porcini)
        let provider = getWeb3Provider(url: url, networkName: NetworkName.porcini)
        let web3 = Web3(provider: provider)
        
        
        let tokenContract = try assetIdToERC20Address(assetId: ROOT_ID)
        
        let address = EthereumAddress(hexString: "0x55D77A60Fd951117f531D2277a5BB4aFbE3fB292")!
        
        let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: tokenContract)
        let output = try contract.balanceOf(address: address).call().wait()
        let balance = output["_balance"] as! BigUInt
        
        XCTAssertGreaterThanOrEqual(balance, BigUInt.zero)
        
    }
}
