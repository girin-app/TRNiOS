import Foundation
import XCTest
import Web3
import Web3PromiseKit
import Web3ContractABI
import BigInt

@testable import TRNiOS

final class Transfer: XCTestCase {

    func testNativeTransfer() async throws {
        let url = getPublicProviderUrl(network: NetworkName.porcini)
        let provider = getWeb3Provider(url: url, networkName: NetworkName.porcini)
        let web3 = Web3(provider: provider)
        
        let fromPrivateKey = try EthereumPrivateKey(hexPrivateKey: "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65")
        let toAddress = EthereumAddress(hexString: "0xE2640ae2A8DFeCB460C1062425b5FD314B6E60D5")!
        let amount = EthereumQuantity(quantity: 1.eth)
        
        let block = try web3.eth.getBlockByNumber(block: .latest, fullTransactionObjects: false).wait()
        let nonce = try web3.eth.getTransactionCount(address: fromPrivateKey.address, block: .latest).wait()
        
        let tx = EthereumTransaction(
            nonce: nonce,
            maxFeePerGas: block?.baseFeePerGas,
            maxPriorityFeePerGas: EthereumQuantity(quantity: BigUInt.zero),
            gasLimit: 21000,
            to: toAddress,
            value: amount,
            transactionType: .eip1559
        )
        
        let signedTx = try tx.sign(with: fromPrivateKey, chainId: 7672)
        let hash = try web3.eth.sendRawTransaction(transaction: signedTx).wait()
        print(hash.hex())
    }
    
    func testErc20TransferRoot() async throws {
        let url = getPublicProviderUrl(network: NetworkName.porcini)
        let provider = getWeb3Provider(url: url, networkName: NetworkName.porcini)
        let web3 = Web3(provider: provider)
        
        let fromPrivateKey = try EthereumPrivateKey(hexPrivateKey: "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65")
        let toAddress = EthereumAddress(hexString: "0xE2640ae2A8DFeCB460C1062425b5FD314B6E60D5")!
        let amount = BigUInt(1)
        
        let nonce = try web3.eth.getTransactionCount(address: fromPrivateKey.address, block: .latest).wait()
        
        let rootAddress = try assetIdToERC20Address(assetId: ROOT_ID)
        let rootContract = web3.eth.Contract(type: GenericERC20Contract.self, address: rootAddress)
        let output = try rootContract.decimals().call().wait()
        let decimals = output["_decimals"] as! UInt8
        
        let decimalValue = BigUInt(10).power(Int(decimals))
        
        let transfer = rootContract.transfer(to: toAddress, value: amount.multiplied(by: decimalValue))
        let gaslimit = try transfer.estimateGas(from: fromPrivateKey.address).wait()
        let block = try web3.eth.getBlockByNumber(block: .latest, fullTransactionObjects: false).wait()
        
        let tx = transfer.createTransaction(nonce: nonce, gasPrice: nil, maxFeePerGas: block?.baseFeePerGas, maxPriorityFeePerGas: EthereumQuantity(quantity: BigUInt.zero), gasLimit: gaslimit, from: fromPrivateKey.address, value: 0, accessList: [:], transactionType: .eip1559)
        
        let signedTx = try tx?.sign(with: fromPrivateKey, chainId: 7672)
        let txHash = try web3.eth.sendRawTransaction(transaction: signedTx!).wait()
        print(txHash.hex())
        
    }
    
    func testFeeProxyTransfer() async throws {
        // init provider
        let url = getPublicProviderUrl(network: NetworkName.porcini)
        let provider = getWeb3Provider(url: url, networkName: NetworkName.porcini)
        let web3 = Web3(provider: provider)
        
        // prepare erc20 contract transfer
        let fromPrivateKey = try EthereumPrivateKey(hexPrivateKey: "0xf28c395640d7cf3a8b415d12f741a0299b34cb0c7af7d2ba6440d9f2d3880d65")
        let toAddress = EthereumAddress(hexString: "0xE2640ae2A8DFeCB460C1062425b5FD314B6E60D5")!
        let amount = BigUInt(1)
        
        let nonce = try web3.eth.getTransactionCount(address: fromPrivateKey.address, block: .latest).wait()
        
        let rootAddress = try assetIdToERC20Address(assetId: ROOT_ID)
        let rootContract = web3.eth.Contract(type: GenericERC20Contract.self, address: rootAddress)
        let output = try rootContract.decimals().call().wait()
        let decimals = output["_decimals"] as! UInt8
        let decimalValue = BigUInt(10).power(Int(decimals))
        let transfer = rootContract.transfer(to: toAddress, value: amount.multiplied(by: decimalValue))
        
        // calculate fee
        let gaslimit = try transfer.estimateGas(from: fromPrivateKey.address).wait()
        let res = try await getFeeProxyPricePair(web3: web3, gasEstimate: gaslimit.quantity, feeAssetId: ROOT_ID, slippage: 0.05)
        
        // prepare feeproxy contract
        let feeProxyContract = web3.eth.Contract(type: GenericFeeProxyContract.self, address: EthereumAddress(hexString: FEE_PROXY_PRECOMPILE_ADDRESS))
        
        let r = feeProxyContract.callWithFeePreferences(asset: rootAddress, maxPayment: res.maxPayment, target: rootAddress, input: transfer.encodeABI()!)
        
        // create tx
        let tx = r.createTransaction(nonce: nonce, gasPrice: nil, maxFeePerGas: EthereumQuantity(quantity: res.maxFeePerGas), maxPriorityFeePerGas: EthereumQuantity(quantity: BigUInt.zero), gasLimit: gaslimit, from: fromPrivateKey.address, value: 0, accessList: [:], transactionType: .eip1559)
        
        // sign tx
        let signedTx = try tx?.sign(with: fromPrivateKey, chainId: 7672)
        
        // send tx
        let txHash = try web3.eth.sendRawTransaction(transaction: signedTx!).wait()
        print(txHash.hex())
    }
}
