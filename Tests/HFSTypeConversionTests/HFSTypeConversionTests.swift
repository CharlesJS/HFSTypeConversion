//
//  StringConversionTests.swift
//  CSFileInfo
//
//  Created by Charles Srstka on 9/5/24.
//

import Foundation
import HFSTypeConversion
import Testing

@Test("Create String from HFS Type Code")
func testCreateStringFromTypeCode() {
    #expect(String(hfsTypeCode: 0) == "")
    #expect(String(hfsTypeCode: 0x4d6f6f66) == "Moof")
    #expect(String(hfsTypeCode: 0x6d3099c4) == "m0ôƒ")
    #expect(String(hfsTypeCode: 0xf0b9c0aa) == "π¿™")
}

@Test("Convert String to HFS Type Code")
func testConvertStringToTypeCode() {
    #expect("".hfsTypeCode == 0)
    #expect("abcd".hfsTypeCode == 0x61626364)
    #expect("Mõøƒ".hfsTypeCode == 0x4d9bbfc4)
    #expect("TooLong".hfsTypeCode == 0x546f6f4c)
    #expect("tny".hfsTypeCode == 0x746e7920)
    #expect("no!😱".hfsTypeCode == nil)
}

@Test("Create String from Mac OS Roman String Data")
func testCreateStringFromMacOSRomanStringData() {
    #expect(String(macOSRomanData: []) == "")
    #expect(String(macOSRomanData: [0x46, 0x6f, 0x6f, 0x20, 0x42, 0x61, 0x72]) == "Foo Bar")
    #expect(String(macOSRomanData: [0xd2, 0xa4, 0xd8, 0xb5, 0x62, 0x97, 0xa3, 0xa7, 0xd3]) == "“§ÿµbó£ß”")
}

@Test("Create String from Mac OS Roman C String Data")
func testCreateStringFromMacOSRomanCString() {
    #expect(String(macOSRomanCStringData: []) == "")
    #expect(String(macOSRomanCStringData: [0, 0, 0]) == "")
    #expect(String(macOSRomanCStringData: [0x46, 0x6f, 0x6f, 0x20, 0x42, 0x61, 0x72]) == "Foo Bar")
    #expect(String(macOSRomanCStringData: [0x46, 0x6f, 0x6f, 0x20, 0x42, 0x61, 0x72, 0x00, 0x00]) == "Foo Bar")
    #expect(String(macOSRomanCStringData: [0xd2, 0xa4, 0xd8, 0xb5, 0x62, 0x97, 0xa3, 0xa7, 0xd3]) == "“§ÿµbó£ß”")
    #expect(String(macOSRomanCStringData: [0xd2, 0xa4, 0xd8, 0xb5, 0x62, 0x97, 0xa3, 0xa7, 0xd3, 0x00]) == "“§ÿµbó£ß”")
}

@Test("Convert String to Mac OS Roman C String")
func testConvertStringToMacOSRomanCString() {
    #expect(String("").macOSRomanCString(allowLossyConversion: true) == [])
    #expect(String("").macOSRomanCString(allowLossyConversion: false) == [])
    #expect(String("Moof!").macOSRomanCString(allowLossyConversion: true) == [0x4d, 0x6f, 0x6f, 0x66, 0x21])
    #expect(String("Moof!").macOSRomanCString(allowLossyConversion: false) == [0x4d, 0x6f, 0x6f, 0x66, 0x21])
    #expect(String("π°◊‰√Ω").macOSRomanCString(allowLossyConversion: true) == [0xb9, 0xa1, 0xd7, 0xf0, 0xe4, 0xc3, 0xbd])
    #expect(String("Some 😈bad😈 characters").macOSRomanCString(allowLossyConversion: false) == nil)
    #expect(
        String("Some 😈bad😈 characters").macOSRomanCString(allowLossyConversion: true) ==
        String("Some bad characters").macOSRomanCString(allowLossyConversion: false)
    )
}

@Test("Case conversion")
func testCaseConversion() {
    for c in UInt8.min..<UInt8.max {
        if let expectedChar = String(bytes: [c], encoding: .macOSRoman)?.lowercased().data(using: .macOSRoman)?.first {
            #expect(c.toMacOSRomanLowerCase() == expectedChar)
        }
    }
}
