import SwiftUI

struct DetailPanelView: View {
    let session: Session
    @State private var selectedTab: DetailTab = .memory
    
    enum DetailTab: String, CaseIterable {
        case memory = "Memory"
        case skills = "Skills"
        case tools = "Tools"
        case tasks = "Tasks"
        case insights = "Insights"
        case files = "Files"
        
        var icon: String {
            switch self {
            case .memory: return "brain.head.profile"
            case .skills: return "book.closed"
            case .tools: return "wrench.and.screwdriver"
            case .tasks: return "clock"
            case .insights: return "chart.bar"
            case .files: return "folder"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab picker
            Picker("", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: tab.icon).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Divider()
            
            // Tab content
            Group {
                switch selectedTab {
                case .memory:
                    MemoryTabView()
                case .skills:
                    SkillsTabView()
                case .tools:
                    ToolsTabView()
                case .tasks:
                    TasksTabView()
                case .insights:
                    InsightsTabView()
                case .files:
                    FilesTabView()
                }
            }
        }
        .background(Color.surfaceDark)
    }
}

struct MemoryTabView: View {
    @State private var searchText = ""
    @State private var entries: [MemoryEntry] = []
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search memory...", text: $searchText)
            }
            .padding(8)
            .background(Color.surfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
            
            if entries.isEmpty {
                EmptyStateView(
                    icon: "brain.head.profile",
                    title: "No Memory Entries",
                    subtitle: "Memory entries will appear here as you interact with Hermes"
                )
            } else {
                List(entries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.key)
                            .font(.headline)
                        Text(entry.value)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
            }
        }
    }
}

struct SkillsTabView: View {
    var body: some View {
        EmptyStateView(
            icon: "book.closed",
            title: "No Skills Yet",
            subtitle: "Learned skills will appear here"
        )
    }
}

struct ToolsTabView: View {
    var body: some View {
        EmptyStateView(
            icon: "wrench.and.screwdriver",
            title: "Tool Registry",
            subtitle: "Browse and test available tools"
        )
    }
}

struct TasksTabView: View {
    var body: some View {
        EmptyStateView(
            icon: "clock",
            title: "No Scheduled Tasks",
            subtitle: "Create automations to run on schedule"
        )
    }
}

struct InsightsTabView: View {
    var body: some View {
        VStack {
            Text("Usage Insights")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

struct FilesTabView: View {
    var body: some View {
        EmptyStateView(
            icon: "folder",
            title: "Workspace Files",
            subtitle: "Browse files in your workspace"
        )
    }
}

#Preview {
    DetailPanelView(session: Session(id: "1", title: "Test", createdAt: Date(), updatedAt: Date(), isPinned: false))
        .frame(width: 300, height: 500)
}
