import SwiftUI

struct ContentView: View {
    @StateObject private var auth = SpotifyAuth.shared
    @StateObject private var engine = LyricsSyncEngine()
    @AppStorage(SpotifyConfiguration.storageKey)
    private var clientID = SpotifyConfiguration.defaultClientID

    var body: some View {
        VStack(spacing: 20) {
            Text("Lyrics for CarPlay")
                .font(.title2.bold())

            if auth.isAuthorized {
                VStack(spacing: 8) {
                    Text(engine.currentTrack?.name ?? "No track yet")
                        .font(.headline)
                    Text(engine.currentTrack?.artist ?? "")
                        .foregroundStyle(.secondary)
                    Text(engine.currentLine)
                        .padding()
                        .multilineTextAlignment(.center)
                    Text(engine.statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .onAppear { engine.start() }
                .onDisappear { engine.stop() }
            } else {
                Text("Your Spotify app is configured. Connect your account to start lyrics.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                DisclosureGroup("Spotify app settings") {
                    TextField("Spotify Client ID", text: $clientID)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    Text("Use the Client ID, not the Client Secret.")
                        .font(.caption)
                }
                Button("Connect Spotify") {
                    auth.login()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!SpotifyConfiguration.isValid(clientID.trimmingCharacters(in: .whitespacesAndNewlines)))
            }
        }
        .padding()
    }
}
