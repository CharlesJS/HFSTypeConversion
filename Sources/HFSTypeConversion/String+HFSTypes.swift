//
//  String+HFSTypes.swift
//  CSFileInfo
//
//  Created by Charles Srstka on 9/4/24.
//

extension String {
    // HFS type codes assumed to be in big-endian format
    public init(hfsTypeCode: UInt32) {
        var bigInt = hfsTypeCode.bigEndian

        self = withUnsafeBytes(of: &bigInt) {
            String($0[..<($0.firstIndex(of: 0) ?? $0.endIndex)].map { Self.convertToMacOSRoman($0) })
        }
    }

    public var hfsTypeCode: UInt32? {
        if self.isEmpty { return 0 }

        guard var bytes = self.prefix(4).map({ Self.convertFromMacOSRoman($0) }) as? [UInt8] else { return nil }
        while bytes.count < 4 {
            bytes.append(0x20)
        }

        return bytes.withUnsafeBytes { UInt32(bigEndian: $0.load(as: UInt32.self)) }
    }
}
