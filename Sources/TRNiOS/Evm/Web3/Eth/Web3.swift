import Foundation

import Web3
import PromiseKit

public struct AmountsIn: Codable {
    let Ok: [UInt]
}

public extension Web3.Eth {
    func getAmountsIn(gasCostInXRP: Int, feeAssetID: Int) -> Promise<UInt> {
        return Promise { seal in
            self.getAmountsIn(gasCostInXRP: gasCostInXRP, feeAssetID: feeAssetID) { response in
                if let err = response.error {
                    seal.reject(err)
                    return
                }
            
                guard let maxPayment = response.result?.Ok.first else {
                    let error = NSError(domain: "feeproxy", code: 0, userInfo: [NSLocalizedDescriptionKey: "unknown maxPayments"])
                    seal.reject(error)
                    return
                }
                    
                seal.resolve(maxPayment, nil)
            }
        }
    }
}

extension Web3.Eth {
    func getAmountsIn(
        gasCostInXRP: Int,
        feeAssetID: Int,
        response: @escaping Web3.Web3ResponseCompletion<AmountsIn>
    ) {
        let req = BasicRPCRequest(
            id: properties.rpcId,
            jsonrpc: Web3.jsonrpc,
            method: "dex_getAmountsIn",
            params: [
                gasCostInXRP,
                EthereumValue(array: [feeAssetID, XRP_ID])
            ]
        )

        properties.provider.send(request: req, response: response)
    }
}
