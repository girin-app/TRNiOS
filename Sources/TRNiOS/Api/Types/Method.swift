
import Foundation
import BigInt
import Web3

public protocol Method {
    var callIndex: [UInt8] { get }
    func toU8a() -> [UInt8]
}

public struct MethodWithdrawXrp: Method {
    public let callIndex: [UInt8] = Data(hex: "1203").bytes
    var args: WithdrawXrpArgs
    
    public init(args: WithdrawXrpArgs) {
        self.args = args
    }
    
    public func toU8a() -> [UInt8] {
        var u8a = callIndex
        u8a += bnToU8a(bn: args.amount.quantity, bitLength: 128)
        u8a += args.destination.rawAddress
        return u8a
    }
}

public struct WithdrawXrpArgs {
    let amount: EthereumQuantity
    let destination: EthereumAddress
    
    public init(amount: EthereumQuantity, destination: EthereumAddress) {
        self.amount = amount
        self.destination = destination
    }
}

public struct MethodFeeProxy: Method {
    public let callIndex: [UInt8] = Data(hex: "1f00").bytes
    public var args: FeeProxyArgs
    
    public init(args: FeeProxyArgs) {
        self.args = args
    }

    public func toU8a() -> [UInt8] {
        var u8a = callIndex
        u8a.append(contentsOf: bnToU8a(bn: args.paymentAsset, bitLength: 32))
        u8a.append(contentsOf: bnToU8a(bn: args.maxPayment, bitLength: 128))
        u8a.append(contentsOf: args.call.toU8a())
        return u8a
    }
}

public struct FeeProxyArgs {
    let paymentAsset: BigUInt
    public var maxPayment: BigUInt
    let call: MethodWithdrawXrp
    
    public init(paymentAsset: BigUInt, maxPayment: BigUInt, call: MethodWithdrawXrp) {
        self.paymentAsset = paymentAsset
        self.maxPayment = maxPayment
        self.call = call
    }
}
