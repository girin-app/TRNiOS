
import Foundation
import BigInt
import Web3

protocol Method {
    var callIndex: [UInt8] { get }
    func toU8a() -> [UInt8]
}

struct MethodWithdrawXrp: Method {
    let callIndex: [UInt8] = Data(hex: "1203").bytes
    let args: WithdrawXrpArgs

    func toU8a() -> [UInt8] {
        var u8a = callIndex
        u8a += bnToU8a(bn: args.amount.quantity, bitLength: 128)
        u8a += args.destination.rawAddress
        return u8a
    }
}

struct WithdrawXrpArgs {
    let amount: EthereumQuantity
    let destination: EthereumAddress
}

struct MethodFeeProxy: Method {
    let callIndex: [UInt8] = Data(hex: "1f00").bytes
    let args: FeeProxyArgs

    func toU8a() -> [UInt8] {
        var u8a = callIndex
        u8a.append(contentsOf: bnToU8a(bn: args.paymentAsset, bitLength: 32))
        u8a.append(contentsOf: bnToU8a(bn: args.maxPayment, bitLength: 128))
        u8a.append(contentsOf: args.call.toU8a())
        return u8a
    }
}

struct FeeProxyArgs {
    let paymentAsset: BigUInt
    let maxPayment: BigUInt
    let call: MethodWithdrawXrp
}
