//
//  Date+Extensions.swift
//  Pictorium
//
//  Created by Simon Butenko on 04.03.2024.
//

import Foundation

let iso8601DateFormatter = ISO8601DateFormatter()

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    func formatToString() -> String {
        dateFormatter.string(from: self)
    }
}
