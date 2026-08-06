import SwiftUI

struct ChatView: View {
    let session: Session
    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubbleView(message: message)
                                .id(message.id)
                        }
                        
                        if isLoading {
                            HStack {
                                PulsingDot(color: Color.hermesPurple)
                                Text("Hermes is thinking...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
                    if let last = messages.last {
                        withAnimation { proxy.scrollTo(last.id) }
                    }
                }
            }
            
            // Composer
            ComposerBarView(messageText: $messageText) { text in
                sendMessage(text)
            } onAttach: {
                // Handle attachment
            }
        }
        .background(Color.surfaceDark)
        .onAppear {
            loadMessages()
        }
    }
    
    private func loadMessages() {
        // Placeholder - will load from API
        messages = [
            ChatMessage(id: "1", role: .user, content: "Help me refactor the authentication module", timestamp: Date().addingTimeInterval(-120)),
            ChatMessage(id: "2", role: .assistant, content: "I'll analyze the authentication module and suggest improvements. Let me examine the code structure first...", timestamp: Date().addingTimeInterval(-60)),
            ChatMessage(id: "3", role: .user, content: "Focus on error handling and token management", timestamp: Date().addingTimeInterval(-30))
        ]
    }
    
    private func sendMessage(_ text: String) {
        let userMessage = ChatMessage(id: UUID().uuidString, role: .user, content: text, timestamp: Date())
        messages.append(userMessage)
        messageText = ""
        isLoading = true
        
        // Simulate response
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                let response = ChatMessage(id: UUID().uuidString, role: .assistant, content: "I understand. Let me help you with that...", timestamp: Date())
                messages.append(response)
                isLoading = false
            }
        }
    }
}

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .top) {
            if message.role == .assistant {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(Color.hermesPurple)
                    .frame(width: 24)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .textSelection(.enabled)
                    .padding(12)
                    .background(message.role == .user ? Color.hermesPurple.opacity(0.2) : Color.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            if message.role == .user {
                Image(systemName: "person.circle.fill")
                    .foregroundStyle(.secondary)
                    .frame(width: 24)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
    }
}

#Preview {
    ChatView(session: Session(id: "1", title: "Test", createdAt: Date(), updatedAt: Date(), isPinned: false))
        .frame(width: 500, height: 400)
}
