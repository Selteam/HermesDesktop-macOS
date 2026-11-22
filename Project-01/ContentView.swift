import SwiftUI
import Observation

struct ContentView: View {
    @Environment(AuthManager.self) var auth
    @State private var selectedSession: Session?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $selectedSession)
        } content: {
            if let session = selectedSession {
                ChatView(session: session)
            } else {
                WelcomeView()
            }
        } detail: {
            if let session = selectedSession {
                DetailPanelView(session: session)
            } else {
                EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 64))
                .foregroundStyle(Color.hermesPurple.opacity(0.6))
            
            Text("Select a conversation")
                .font(.title2)
                .foregroundStyle(.secondary)
            
            Text("Or create a new chat to get started")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surfaceDark)
    }
}

#Preview {
    ContentView()
        .environment(AuthManager())
}
