import Foundation

enum SpotifyConfiguration {
    // OAuth client identifiers are public metadata, not client secrets.
    static let defaultClientID = "23eac405446a46fc8ea93c9ddbc70718"
    static let storageKey = "spotify_client_id"

    static var clientID: String {
        (UserDefaults.standard.string(forKey: storageKey) ?? defaultClientID)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func isValid(_ value: String) -> Bool {
        value.range(of: "^[a-fA-F0-9]{32}$", options: .regularExpression) != nil
    }
}
