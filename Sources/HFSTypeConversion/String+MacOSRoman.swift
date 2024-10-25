//
//  String+MacOSRoman.swift
//  HFSTypeConversion
//
//  Created by Charles Srstka on 9/6/24.
//

extension String {
    private static let specialsMacOSRomanToCharacter: [UInt8 : Character] = [
        0x80: "Ä", 0x81: "Å", 0x82: "Ç", 0x83: "É", 0x84: "Ñ", 0x85: "Ö", 0x86: "Ü", 0x87: "á", 0x88: "à", 0x89: "â",
        0x8a: "ä", 0x8b: "ã", 0x8c: "å", 0x8d: "ç", 0x8e: "é", 0x8f: "è", 0x90: "ê", 0x91: "ë", 0x92: "í", 0x93: "ì",
        0x94: "î", 0x95: "ï", 0x96: "ñ", 0x97: "ó", 0x98: "ò", 0x99: "ô", 0x9a: "ö", 0x9b: "õ", 0x9c: "ú", 0x9d: "ù",
        0x9e: "û", 0x9f: "ü", 0xa0: "†", 0xa1: "°", 0xa2: "¢", 0xa3: "£", 0xa4: "§", 0xa5: "•", 0xa6: "¶", 0xa7: "ß",
        0xa8: "®", 0xa9: "©", 0xaa: "™", 0xab: "´", 0xac: "¨", 0xad: "≠", 0xae: "Æ", 0xaf: "Ø", 0xb0: "∞", 0xb1: "±",
        0xb2: "≤", 0xb3: "≥", 0xb4: "¥", 0xb5: "µ", 0xb6: "∂", 0xb7: "∑", 0xb8: "∏", 0xb9: "π", 0xba: "∫", 0xbb: "ª",
        0xbc: "º", 0xbd: "Ω", 0xbe: "æ", 0xbf: "ø", 0xc0: "¿", 0xc1: "¡", 0xc2: "¬", 0xc3: "√", 0xc4: "ƒ", 0xc5: "≈",
        0xc6: "∆", 0xc7: "«", 0xc8: "»", 0xc9: "…", 0xca: " ", 0xcb: "À", 0xcc: "Ã", 0xcd: "Õ", 0xce: "Œ", 0xcf: "œ",
        0xd0: "–", 0xd1: "—", 0xd2: "“", 0xd3: "”", 0xd4: "‘", 0xd5: "’", 0xd6: "÷", 0xd7: "◊", 0xd8: "ÿ", 0xd9: "Ÿ",
        0xda: "⁄", 0xdb: "€", 0xdc: "‹", 0xdd: "›", 0xde: "ﬁ", 0xdf: "ﬂ", 0xe0: "‡", 0xe1: "·", 0xe2: "‚", 0xe3: "„",
        0xe4: "‰", 0xe5: "Â", 0xe6: "Ê", 0xe7: "Á", 0xe8: "Ë", 0xe9: "È", 0xea: "Í", 0xeb: "Î", 0xec: "Ï", 0xed: "Ì",
        0xee: "Ó", 0xef: "Ô", 0xf0: "", 0xf1: "Ò", 0xf2: "Ú", 0xf3: "Û", 0xf4: "Ù", 0xf5: "ı", 0xf6: "ˆ", 0xf7: "˜",
        0xf8: "¯", 0xf9: "˘", 0xfa: "˙", 0xfb: "˚", 0xfc: "¸", 0xfd: "˝", 0xfe: "˛", 0xff: "ˇ"
    ]

    private static let specialsCharacterToMacOSRoman = [Character : UInt8](
        uniqueKeysWithValues: Self.specialsMacOSRomanToCharacter.map { ($0.1, $0.0) }
    )

    internal static func convertToMacOSRoman(_ byte: UInt8) -> Character {
        if byte < 0x80 {
            return Character(UnicodeScalar(byte))
        } else {
            return self.specialsMacOSRomanToCharacter[byte]!
        }
    }

    internal static func convertFromMacOSRoman(_ character: Character) -> UInt8? {
        if character.unicodeScalars.count == 1, let scalar = character.unicodeScalars.first?.value, scalar < 0x80 {
            return UInt8(scalar)
        } else {
            return self.specialsCharacterToMacOSRoman[character]
        }
    }

    public init(macOSRomanData: some Sequence<UInt8>) {
        self = String(macOSRomanData.map { Self.convertToMacOSRoman($0) })
    }

    public init(macOSRomanCStringData: some Collection<UInt8>) {
        let terminatorIndex = macOSRomanCStringData.firstIndex(of: 0) ?? macOSRomanCStringData.endIndex
        self.init(macOSRomanData: macOSRomanCStringData[..<terminatorIndex])
    }

    public func macOSRomanCString(allowLossyConversion: Bool = false) -> ContiguousArray<UInt8>? {
        var bytes: ContiguousArray<UInt8> = []

        for character in self {
            if let byte = Self.convertFromMacOSRoman(character) {
                bytes.append(byte)
            } else if !allowLossyConversion {
                return nil
            }
        }

        return bytes
    }
}
