import Foundation
import BigInt

let MAX_U8 = BigUInt(2).power(6) // 64
let MAX_U16 = BigUInt(2).power(14) // 16384
let MAX_U32 = BigUInt(2).power(30) // 1073741824

public func bnToU8aLittleEndian(value: BigUInt, bitLength: Int) -> [UInt8] {
    let data = bnToU8a(bn: value)
    let paddedData = data + Data(count: bitLength/8 - data.count)
    return [UInt8](paddedData)
}

public func compactToU8a(_ value: BigUInt) throws -> [UInt8] {
    if value <= MAX_U8 {
        return [try UInt8(value << 2)]
    } else if value <= MAX_U16 {
        let shiftedValue = (value << 2) + 1
        return bnToU8aLittleEndian(value: shiftedValue, bitLength: 16)
    } else if value <= MAX_U32 {
        let shiftedValue = (value << 2) + 2
        return bnToU8aLittleEndian(value: shiftedValue, bitLength: 32)
    }
    
    let u8a = bnToU8a(bn: value)
    var length = u8a.count
    
    while(u8a[length - 1] == 0) {
        length -= 1
    }
    
    if length < 4 {
        throw NSError(domain: "compactToU8a", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid length, previous checks match anything less than 2^30"])
    }
    
    return u8aConcatStrict(u8as: [
        // subtract 4 as minimum (also catered for in decoding)
        [UInt8((length - 4) << 2) + 0b11],
        Array(u8a[0..<length])
      ])
}

public func bnToU8a(bn: BigUInt, bitLength: Int = -1, isLe: Bool = true) -> [UInt8] {
    let byteLength = bitLength == -1 ? Int(ceil(Double(bn.bitWidth) / 8)) : Int(ceil(Double(bitLength) / 8))
    
    if bn == 0 {
        return bitLength == -1 ? [0] : [UInt8](repeating: 0, count: byteLength)
    }
    
    var output = [UInt8](repeating: 0, count: byteLength)
       
    let bnArray = bn.serialize().suffix(byteLength)

    if isLe {
        let res = Array(bnArray.reversed())
        for i in 0...res.count-1 {
            output[i] = res[i]
        }
    } else {
        let res = Array(bnArray)
        for i in 0...res.count-1 {
            output[i] = res[i]
        }
    }

    return output
}

public func u8aConcatStrict(u8as: [[UInt8]]) -> [UInt8] {
    let count = u8as.count
    var offset = 0
    var result = [UInt8]()

    var length = 0
    if length == 0 {
        for i in 0..<count {
            length += u8as[i].count
        }
    }

    result.reserveCapacity(length)

    for i in 0..<count {
        result.append(contentsOf: u8as[i])
        offset += u8as[i].count
    }

    return result
}

public func decodeCompact(u8a: [UInt8]) -> (Int, BigUInt) {
    if (u8a[0] & 0b11) < 0b11 {
        return compactFromU8aLim(u8a: u8a)
    } else {
        return compactFromU8a(u8a: u8a)
    }
}

public func compactFromU8a(u8a: [UInt8]) -> (Int, BigUInt) {
    switch u8a[0] & 0b11 {
    case 0b00:
        return (1, BigUInt(Int(u8a[0] >> 2)))
    case 0b01:
        let value = (Int(u8a[0]) + (Int(u8a[1]) << 8)) >> 2
        return (2, BigUInt(value))
    case 0b10:
        let value = (Int(u8a[0]) + (Int(u8a[1]) << 8) + (Int(u8a[2]) << 16) + (Int(u8a[3]) << 24)) >> 2
        return (4, BigUInt(value))
    default:
        let offset = (Int(u8a[0]) >> 2) + 5
        switch offset {
        case 5:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + (Int(u8a[4]) << 24)
            return (5, BigUInt(value))
        case 6:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + ((Int(u8a[4]) + (Int(u8a[5]) << 8)) << 24)
            return (6, BigUInt(value))
        case 7:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + ((Int(u8a[4]) + (Int(u8a[5]) << 8) + (Int(u8a[6]) << 16)) << 24)
            return (7, BigUInt(value))
        default:
            let data = Array(u8a[1..<Int(offset)])
            let value = BigUInt(data)
            return (Int(offset), value)
        }
    }
}

public func compactFromU8aLim(u8a: [UInt8]) -> (Int, BigUInt) {
    switch u8a[0] & 0b11 {
    case 0b00:
        return (1, BigUInt(Int(u8a[0]) >> 2))
    case 0b01:
        let value = (Int(u8a[0]) + (Int(u8a[1]) << 8)) >> 2
        return (2, BigUInt(value))
    case 0b10:
        let value = (Int(u8a[0]) + (Int(u8a[1]) << 8) + (Int(u8a[2]) << 16) + (Int(u8a[3]) << 24)) >> 2
        return (4, BigUInt(value))
    default:
        let offset = (Int(u8a[0]) >> 2) + 5
        switch offset {
        case 5:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + (Int(u8a[4]) << 24)
            return (5, BigUInt(value))
        case 6:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + ((Int(u8a[4]) + (Int(u8a[5]) << 8)) << 24)
            return (6, BigUInt(value))
        case 7:
            let value = Int(u8a[1]) + (Int(u8a[2]) << 8) + (Int(u8a[3]) << 16) + ((Int(u8a[4]) + (Int(u8a[5]) << 8) + (Int(u8a[6]) << 16)) << 24)
            return (7, BigUInt(value))
        default:
            fatalError("Compact input is > Number.MAX_SAFE_INTEGER")
        }
    }
}