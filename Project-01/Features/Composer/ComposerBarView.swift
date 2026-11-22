import SwiftUI

struct ComposerBarView: View {
    @Binding var messageText: String
    @State private var selectedModel: String = "Claude 3.5 Sonnet"
    @State private var reasoningEffort: ReasoningEffort = .medium
    @State private var selectedProfile: String = "Default"
    @State private var selectedWorkspace: String = "~/"
    
    var onSend: (String) -> Void
    var onAttach: () -> Void
    
    enum ReasoningEffort: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Prompt area
            HStack(alignment: .bottom) {
                Button(action: onAttach) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                
                TextField("Message Hermes...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...8)
                    .font(HermesFont.font(.composerText))
                
                Button {
                    onSend(messageText)
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(messageText.isEmpty ? Color.secondary : Color.hermesPurple)
                }
                .buttonStyle(.plain)
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            // Runtime controls row
            HStack(spacing: 12) {
                ModelPickerButton(selection: $selectedModel)
                ReasoningSelector(effort: $reasoningEffort)
                ProfilePickerButton(selection: $selectedProfile)
                WorkspacePickerButton(path: $selectedWorkspace)
                Spacer()
                Button {
                    // Slash commands
                } label: {
                    Text("/cmd")
                        .font(HermesFont.font(.composerControls))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .glassEffect()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

struct ModelPickerButton: View {
    @Binding var selection: String
    
    var body: some View {
        Menu {
            ForEach(["Claude 3.5 Sonnet", "Claude 3 Opus", "GPT-4o", "GPT-4 Turbo", "o1", "Gemini Pro"], id: \.self) { model in
                Button(model) { selection = model }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "brain")
                    .font(.caption)
                Text(selection)
                    .font(HermesFont.font(.composerControls))
            }
            .foregroundStyle(.primary)
        }
        .menuStyle(.borderlessButton)
    }
}

struct ReasoningSelector: View {
    @Binding var effort: ComposerBarView.ReasoningEffort
    
    var body: some View {
        Picker("Reasoning", selection: $effort) {
            ForEach(ComposerBarView.ReasoningEffort.allCases, id: \.self) { e in
                Text(e.rawValue).tag(e)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 180)
    }
}

struct ProfilePickerButton: View {
    @Binding var selection: String
    
    var body: some View {
        Menu {
            ForEach(["Default", "Development", "Production", "Testing"], id: \.self) { profile in
                Button(profile) { selection = profile }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "person.circle")
                    .font(.caption)
                Text(selection)
                    .font(HermesFont.font(.composerControls))
            }
            .foregroundStyle(.primary)
        }
        .menuStyle(.borderlessButton)
    }
}

struct WorkspacePickerButton: View {
    @Binding var path: String
    
    var body: some View {
        Menu {
            ForEach(["~/", "~/Projects", "~/Developer", "~/Code"], id: \.self) { p in
                Button(p) { path = p }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "folder")
                    .font(.caption)
                Text(path)
                    .font(HermesFont.font(.composerControls))
                    .lineLimit(1)
            }
            .foregroundStyle(.primary)
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    ComposerBarView(messageText: .constant("Test message"), onSend: { _ in }, onAttach: {})
        .frame(width: 600)
}
