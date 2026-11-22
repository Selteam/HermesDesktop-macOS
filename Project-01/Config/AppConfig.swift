import SwiftUI

enum AppConfig {
    static let appName = "Hermes Desktop"
    static let logSubsystem = "com.hermes.desktop"
    
    struct API {
        static let defaultTimeout: TimeInterval = 60
        static let healthEndpoint = "/health"
        static let authEndpoint = "/api/auth/login"
    }
}
