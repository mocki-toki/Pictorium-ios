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
    init(from meResponseBody: MeResponseBody) {
        self.username = meResponseBody.username

        var name = meResponseBody.firstName
        if let lastName = meResponseBody.lastName {
            name.append(" \(lastName)")
        }

        self.name = name
        self.loginName = "@\(meResponseBody.username)"
        self.bio = meResponseBody.bio ?? "Описание отсутствует"
    }
}
