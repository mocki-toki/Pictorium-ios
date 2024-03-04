//
//  Array+Extensions.swift
//  Pictorium
//
//  Created by Simon Butenko on 04.03.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
