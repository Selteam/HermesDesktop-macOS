import SwiftUI

struct MenuBarView: View {
    @Environment(AuthManager.self) var auth
    @State private var quickMessage = ""
    
    var body: some View {
        VStack(spacing: 12) {
            if auth.state == .loggedIn {
                // Quick chat
                Text("Quick Chat")
                    .font(.headline)
                
                TextField("Ask Hermes...", text: $quickMessage, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                
                HStack {
                    Button("Send") {
                        // Send message
                        quickMessage = ""
                    }
                    .disabled(quickMessage.isEmpty)
                    
                    Spacer()
                    
                    Button("Open App") {
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                }
            } else {
                Text("Not connected")
                    .foregroundStyle(.secondary)
                
                Button("Open Hermes") {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }
            }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
        .frame(width: 280)
    }
}

#Preview {
    MenuBarView()
        .environment(AuthManager())
}
