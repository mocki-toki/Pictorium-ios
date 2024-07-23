//
//  URLRequest.swift
//  Pictorium
//
//  Created by Simon Butenko on 12.07.2024.
//

import Foundation

extension URLRequest {
    mutating func setToken(_ token: String?) {
        if let token = token {
            self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token available")
        }
    }
}
