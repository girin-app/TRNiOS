import Web3

public extension EthereumPrivateKey {
    func signMessage(message: String) throws -> (String) {
        let msg = "\u{19}Ethereum Signed Message:\n\(message.count)\(message)"
        let sig = try self.sign(message: msg.bytes)
        return sig.r.toHexString() + sig.s.toHexString() + String(format: "%02x", sig.v + 27)
    }
}
