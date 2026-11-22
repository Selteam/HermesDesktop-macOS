import SwiftUI

struct OnboardingView: View {
    @Environment(AuthManager.self) var auth
    @State private var serverURLText = ""
    @State private var password = ""
    @State private var isConnecting = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundStyle(Color.hermesPurple)
            
            Text("Hermes Desktop")
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Connect to your Hermes Agent server")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 16) {
                TextField("Server URL", text: $serverURLText)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.URL)
                    
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .frame(maxWidth: 300)
            
            Button {
                Task { await connect() }
            } label: {
                if isConnecting {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Text("Connect")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(serverURLText.isEmpty || password.isEmpty || isConnecting)
        }
        .padding(40)
        .frame(width: 500, height: 400)
    }
    
    private func connect() async {
        isConnecting = true
        errorMessage = nil
        
        defer { isConnecting = false }
        
        guard let url = URL(string: serverURLText) else {
            errorMessage = "Invalid URL"
            return
        }
        
        do {
            try await testConnection(url: url)
            try await MainActor.run { try auth.configureServer(url) }
            try await auth.login(password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func testConnection(url: URL) async throws {
        let healthURL = url.appendingPathComponent(AppConfig.API.healthEndpoint)
        let (_, response) = try await URLSession.shared.data(from: healthURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.invalidResponse
        }
    }
}

#Preview {
    OnboardingView()
        .environment(AuthManager())
}
