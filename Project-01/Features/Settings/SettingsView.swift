import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            ConnectionPane()
                .tabItem {
                    Label("Connection", systemImage: "server.rack")
                }
            
            LLMProviderPane()
                .tabItem {
                    Label("LLM Provider", systemImage: "cpu")
                }
            
            AppearancePane()
                .tabItem {
                    Label("Appearance", systemImage: "paintbrush")
                }
            
            AboutPane()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct ConnectionPane: View {
    @Environment(AuthManager.self) var auth
    @State private var serverURL = ""
    @State private var connectionStatus: ConnectionStatus = .unknown
    
    enum ConnectionStatus {
        case unknown
        case connected
        case disconnected
        case error(String)
    }
    
    var body: some View {
        Form {
            Section("Server") {
                TextField("Server URL", text: $serverURL)
                    .textContentType(.URL)
                    .disableAutocorrection(true)
                    #if os(iOS)
                    
                    #endif
                
                HStack {
                    Button("Test Connection") {
                        testConnection()
                    }
                    
                    Spacer()
                    
                    switch connectionStatus {
                    case .connected:
                        Label("Connected", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    case .disconnected:
                        Label("Disconnected", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    case .error(let message):
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                    case .unknown:
                        EmptyView()
                    }
                }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            serverURL = auth.serverURL?.absoluteString ?? ""
        }
    }
    
    private func testConnection() {
        // Test connection logic
    }
}

struct LLMProviderPane: View {
    @State private var selectedProvider = "OpenAI"
    
    var body: some View {
        Form {
            Section("Provider") {
                Picker("Provider", selection: $selectedProvider) {
                    Text("OpenAI").tag("OpenAI")
                    Text("Anthropic").tag("Anthropic")
                    Text("OpenRouter").tag("OpenRouter")
                    Text("Local (Ollama)").tag("Ollama")
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct AppearancePane: View {
    @State private var glassIntensity = 0.7
    
    var body: some View {
        Form {
            Section("Glass Effect") {
                VStack(alignment: .leading) {
                    Text("Glass Intensity")
                    Slider(value: $glassIntensity, in: 0...1)
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct AboutPane: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 64))
                .foregroundStyle(Color.hermesPurple)
            
            Text("Hermes Desktop")
                .font(.title)
            
            Text("Version 1.0.0")
                .foregroundStyle(.secondary)
            
            Text("A native macOS client for Hermes Agent")
                .font(.caption)
                .foregroundStyle(.tertiary)
            
            Divider()
            
            VStack(spacing: 8) {
                Text("Built with SwiftUI and Liquid Glass")
                Text("UI inspired by Hermex")
                Text("Features powered by Hermes Agent")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .environment(AuthManager())
}
