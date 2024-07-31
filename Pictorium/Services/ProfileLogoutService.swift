//
//  ProfileLogoutService.swift
//  Pictorium
//
//  Created by Simon Butenko on 27.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()

    private init() {}

    func logout() {
        cleanCookies()
        cleanServices()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            for record in records {
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    private func cleanServices() {
        ImagesListService.shared.cleanPhotos()
        OAuth2TokenStorage().token = nil
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanProfileImageURL()
    }
}
