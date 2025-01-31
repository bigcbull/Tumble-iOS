//
//  tumble_iosApp.swift
//  Tumble
//
//  Created by Adis Veletanlic on 11/16/22.
//

import SwiftUI
import PopupView

@main
struct TumbleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        /// Cache the environment variable in app storage (user defaults).
        if let networkSettings = ProcessInfo.processInfo.environment["NETWORK_SETTINGS"] {
            UserDefaults.standard.set(networkSettings, forKey: StoreKey.networkSettings.rawValue)
            UserDefaults.standard.synchronize()
        }
        /// Initialize dependency providers
        _ = Dependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            Root().implementPopupView()
        }
    }
}
