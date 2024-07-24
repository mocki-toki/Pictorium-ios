//
//  URLRequest.swift
//  Pictorium
//
//  Created by Simon Butenko on 12.07.2024.
//

import Foundation

extension URLRequest {
    mutating func setToken(_ token: String?) {
        guard let token else { return }
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
