//
//  Thread+Helpers.swift
//  Pictorium
//
//  Created by Simon Butenko on 04.03.2024.
//

import Foundation

func onMainThread(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}
