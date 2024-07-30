//
//  Profile.swift
//  Pictorium
//
//  Created by Simon Butenko on 24.07.2024.
//

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

extension Profile {
    init(from result: MeResult) {
        self.username = result.username

        var name = result.firstName
        if let lastName = result.lastName {
            name.append(" \(lastName)")
        }

        self.name = name
        self.loginName = "@\(result.username)"
        self.bio = result.bio ?? "Описание отсутствует"
    }
}
