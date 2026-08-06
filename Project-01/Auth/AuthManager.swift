import SwiftUI

@MainActor
@Observable
final class AuthManager {
    enum State {
        case unconfigured
        case loggedOut
        case loggedIn
    }
    
    var state: State = .unconfigured
    var serverURL: URL?
    var sessionCookies: [HTTPCookie] = []
    
    private let serverURLKey = "hermes_server_url"
    
    init() {
        loadStoredCredentials()
    }
    
    func loadStoredCredentials() {
        if let urlString = KeychainStore.load(key: serverURLKey),
           let url = URL(string: urlString) {
            self.serverURL = url
            self.state = .loggedOut
        }
    }
    
    func configureServer(_ url: URL) throws {
        try KeychainStore.save(key: serverURLKey, value: url.absoluteString)
        self.serverURL = url
        self.state = .loggedOut
    }
    
    func login(password: String) async throws {
        guard let baseURL = serverURL else {
            throw AuthError.noServer
        }
        
        let cookies = try await performLogin(baseURL: baseURL, password: password)
        self.sessionCookies = cookies
        self.state = .loggedIn
    }
    
    func logout() {
        KeychainStore.delete(key: serverURLKey)
        serverURL = nil
        sessionCookies = []
        state = .unconfigured
    }
    
    private func performLogin(baseURL: URL, password: String) async throws -> [HTTPCookie] {
        let url = baseURL.appendingPathComponent(AppConfig.API.authEndpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["password": password])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw AuthError.loginFailed(httpResponse.statusCode)
        }
        
        let cookies = HTTPCookieStorage.shared.cookies(for: url) ?? []
        return cookies
    }
}

enum AuthError: LocalizedError {
    case noServer
    case invalidResponse
    case loginFailed(Int)
    
    var errorDescription: String? {
        switch self {
        case .noServer:
            return "No server configured"
        case .invalidResponse:
            return "Invalid server response"
        case .loginFailed(let code):
            return "Login failed with status: \(code)"
        }
    }
}
