import Foundation

struct Mortal {
    let period: UInt64
    let quantizedPhase: UInt64

    init(period: UInt64 = 80, current: UInt64) {
        // Calculate the next power of two
        let nextPowerOfTwo = period.nextPowerOfTwo()

        // Clamp the period between 4 and 1 << 16
        let clampedPeriod = min(max(nextPowerOfTwo, 4), 1 << 16)

        // Calculate the phase
        let phase = current % clampedPeriod

        // Calculate the quantize factor
        let quantizeFactor = max(clampedPeriod >> 12, 1)

        // Calculate the quantized phase
        let quantizedPhase = (phase / quantizeFactor) * quantizeFactor

        self.period = clampedPeriod
        self.quantizedPhase = quantizedPhase
    }
    
    func toMortalEra() -> MortalEra {
        return MortalEra(mortalEra: self.toU8a())
    }
    
    func toU8a() -> Data {
        let period = Int(self.period)
        let trailingZeros = max(1, getTrailingZeros(UInt64(period)) - 1)
        let encoded = min(15, trailingZeros) + ((Int(self.quantizedPhase) / max(period >> 12, 1)) << 4)

        var byteArray: [UInt8] = []
        byteArray.append(UInt8(encoded & 0xff))
        byteArray.append(UInt8(encoded >> 8))

        return Data(byteArray)
    }
    
    func getTrailingZeros(_ value: UInt64) -> Int {
       return value == 0 ? 64 : (value.trailingZeroBitCount)
   }
}

extension UInt64 {
    func nextPowerOfTwo() -> UInt64 {
        var value = self
        value -= 1
        value |= value >> 1
        value |= value >> 2
        value |= value >> 4
        value |= value >> 8
        value |= value >> 16
        value |= value >> 32
        return value + 1
    }
}
