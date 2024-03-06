//
//  Date+Extensions.swift
//  Pictorium
//
//  Created by Simon Butenko on 04.03.2024.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    func formatToString() -> String {
        return dateFormatter.string(from: self)
    }
}
