import Foundation
import Web3

public let ROOT_ID = 1
public let XRP_ID = 2

public func assetIdToERC20Address(assetId: Int) throws -> EthereumAddress {
    let assetIdInHex = String(format: "%08X", assetId)
    return try EthereumAddress(hex: "0xCCCCCCCC\(assetIdInHex.uppercased())000000000000000000000000", eip55: false)
}

public func collectionIdToERC721Address(collectionId: Int) throws -> EthereumAddress {
    let collectionIdInHex = String(format: "%08X", collectionId)
    return try EthereumAddress(hex: "0xAAAAAAAA\(collectionIdInHex.uppercased())000000000000000000000000", eip55: false)
}

public func collectionIdToERC1155Address(collectionId: Int) throws -> EthereumAddress {
    let collectionIdInHex = String(format: "%08X", collectionId)
    return try EthereumAddress(hex: "0xBBBBBBBB\(collectionIdInHex.uppercased())000000000000000000000000", eip55: false)
}
