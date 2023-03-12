//
//  Dependencies.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-03.
//

import Foundation

// Initialize dependencies
actor Dependencies {
    init() {
        @Provider var networkManager = NetworkManager()
        @Provider var notificationManager = NotificationManager()
        @Provider var scheduleService = ScheduleService()
        @Provider var preferenceService = PreferenceService()
        @Provider var courseColorService = CourseColorService()
        @Provider var authManager = AuthManager()
        @Provider var userController = UserController()
        @Provider var toastController = ToastController()
    }
}

