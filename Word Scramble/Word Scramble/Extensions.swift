//
//  Extensions.swift
//  Word Scramble
//
//  Created by Alvaro Orellana on 06-10-24.
//

import Foundation

public extension Array {
    mutating func removeRandomElement() -> Self.Element {
        let randomIndex = Int.random(in: self.startIndex..<self.endIndex)
        let randomElement = self.remove(at: randomIndex)
        return randomElement
    }
}
