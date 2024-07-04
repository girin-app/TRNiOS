import Foundation

import Foundation
import BigInt
import Web3
import Web3ContractABI


/// Base protocol for FeeProxyContract
public protocol FeeProxyContract: EthereumContract {
    func callWithFeePreferences(asset: EthereumAddress, maxPayment: BigUInt, target: EthereumAddress, input: EthereumData) -> SolidityInvocation
}

open class GenericFeeProxyContract: StaticContract, FeeProxyContract {
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    open var constructor: SolidityConstructor?
    
    open var events: [SolidityEvent] {
        return []
    }
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}

public extension FeeProxyContract {
    
    func callWithFeePreferences(asset: EthereumAddress, maxPayment: BigUInt, target: EthereumAddress, input: EthereumData) -> SolidityInvocation {
        print(input.bytes.count)
        let inputs = [
            SolidityFunctionParameter(name: "_asset", type: .address),
            SolidityFunctionParameter(name: "_maxPayments", type: .uint128),
            SolidityFunctionParameter(name: "_target", type: .address),
            SolidityFunctionParameter(name: "_input", type: .bytes(length: nil)),
        ]
        let method = SolidityNonPayableFunction(name: "callWithFeePreferences", inputs: inputs, handler: self)
        return method.invoke(asset, maxPayment, target, Data(input.bytes))
    }
}

