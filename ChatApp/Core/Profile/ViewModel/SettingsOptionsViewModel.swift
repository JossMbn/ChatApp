//
//  SettingsOptionViewModel.swift
//  ChatApp
//
//  Created by Josselin MABILLON on 16/08/2023.
//

import Foundation
import SwiftUI

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notification
    
    var title: String {
        switch self {
        case .darkMode: return "Dark Mode"
        case .activeStatus: return "Active Status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy and Safety"
        case .notification: return "Notification"
        }
    }
    
    var iconName: String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        case .accessibility: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notification: return "bell.circle.fill"
        }
    }
    
    var iconBackgroundColor: Color {
        switch self {
        case .darkMode: return Color("WhiteBlackColor")
        case .activeStatus: return Color(.systemGreen)
        case .accessibility: return Color("WhiteBlackColor")
        case .privacy: return Color(.systemBlue)
        case .notification: return Color(.systemPurple)
        }
    }
    
    var id: Int { return self.rawValue }
}
