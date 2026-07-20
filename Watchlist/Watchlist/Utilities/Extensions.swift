// Extensions.swift
// Hulpfuncties en extensies voor Swift-types.

import SwiftUI

// Extensie voor String om leeg te controleren
extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

// Extensie voor View om een voorbeeldafbeelding te tonen
extension View {
    func placeholderImage() -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            )
    }
}

// Extensie voor Int om naar tijdsduur te converteren
extension Int {
    func minutesToHoursMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60
        
        if hours > 0 {
            return "\(hours)u \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// Extensie voor Double om naar sterren te converteren
extension Double {
    func toStarRating() -> String {
        let rounded = Int(self.rounded())
        return String(repeating: "⭐", count: rounded)
    }
}

// Extensie voor Date om te formateren
extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter.string(from: self)
    }
}
