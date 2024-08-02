import Foundation
import Web3
import Web3PromiseKit
import BigInt

func getFeeProxyPricePair(web3: Web3, gasEstimate: BigUInt, feeAssetId: Int, slippage: Double = 0) async throws -> (maxPayment: BigUInt, maxFeePerGas: BigUInt, estimateGasCost: BigUInt) {
    let block = try web3.eth.getBlockByNumber(block: .latest, fullTransactionObjects: false).wait()
    
    guard let maxFeePerGas = block?.baseFeePerGas else {
        throw NSError(domain: "feeproxy", code: 0, userInfo: [NSLocalizedDescriptionKey: "unknown baseFeePerGas"])
    }
    
    let gasCostInEth = gasEstimate * BigUInt((Double(maxFeePerGas.quantity) * (1 + slippage)).rounded())
    let remainder = gasCostInEth % BigUInt(10).power(12)
    let gasCostInXRP = gasCostInEth / BigUInt(10).power(12) + (remainder > 0 ? 1 : 0)
    
    
    let maxPayment = try web3.eth.getAmountsIn(gasCostInXRP: Int(gasCostInXRP), feeAssetID: feeAssetId).wait()
    
    return (maxPayment: BigUInt(maxPayment), maxFeePerGas: maxFeePerGas.quantity, estimateGasCost: gasCostInXRP)
}
