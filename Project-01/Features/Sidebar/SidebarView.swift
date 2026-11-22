import SwiftUI

struct SidebarView: View {
    @Binding var selection: Session?
    @State private var searchText = ""
    @State private var sessions: [Session] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search sessions...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .glassEffect()
            .padding(.horizontal, 8)
            .padding(.top, 8)
            
            // Session groups
            List(selection: $selection) {
                if !pinnedSessions.isEmpty {
                    Section("★ Pinned") {
                        ForEach(pinnedSessions) { session in
                            SessionRowView(session: session)
                                .tag(session)
                        }
                    }
                }
                
                if !recentSessions.isEmpty {
                    Section("📁 Recent") {
                        ForEach(recentSessions) { session in
                            SessionRowView(session: session)
                                .tag(session)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            
            // Bottom toolbar
            HStack {
                Button {
                    createNewSession()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                Spacer()
                Button {
                    // Settings
                } label: {
                    Image(systemName: "gear")
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Hermes")
        .onAppear {
            loadSessions()
        }
    }
    
    private var pinnedSessions: [Session] {
        sessions.filter { $0.isPinned && !$0.isArchived }
    }
    
    private var recentSessions: [Session] {
        sessions.filter { !$0.isPinned && !$0.isArchived }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
    
    private func loadSessions() {
        // Placeholder - will load from API
        sessions = [
            Session(id: "1", title: "Code Review Session", createdAt: Date(), updatedAt: Date(), isPinned: true, lastMessage: "I've reviewed the changes..."),
            Session(id: "2", title: "API Integration", createdAt: Date().addingTimeInterval(-3600), updatedAt: Date().addingTimeInterval(-1800), isPinned: false, lastMessage: "The endpoints are ready"),
            Session(id: "3", title: "Bug Investigation", createdAt: Date().addingTimeInterval(-7200), updatedAt: Date().addingTimeInterval(-3600), isPinned: false, lastMessage: "Found the issue in...")
        ]
    }
    
    private func createNewSession() {
        let newSession = Session(id: UUID().uuidString, createdAt: Date(), updatedAt: Date(), isPinned: false)
        sessions.insert(newSession, at: 0)
        selection = newSession
    }
}

struct SessionRowView: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(session.displayName)
                .font(HermesFont.font(.sidebarRow))
                .lineLimit(1)
            
            Text(session.preview)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            Text(session.updatedAt.relativeShort)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SidebarView(selection: .constant(nil))
        .frame(width: 250)
}
