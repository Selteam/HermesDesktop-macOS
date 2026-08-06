import SwiftUI

@main
struct HermesDesktopApp: App {
    @State private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.state == .unconfigured {
                    OnboardingView()
                } else {
                    ContentView()
                }
            }
            .environment(authManager)
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified)
        
        Settings {
            SettingsView()
                .environment(authManager)
        }
        
        MenuBarExtra("Hermes", systemImage: "brain.head.profile") {
            MenuBarView()
                .environment(authManager)
        }
        .menuBarExtraStyle(.window)
    }
}
