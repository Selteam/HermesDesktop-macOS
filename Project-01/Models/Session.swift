import SwiftUI

struct Session: Identifiable, Codable, Hashable {
    let id: String
    var title: String?
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    var isArchived: Bool = false
    var projectId: String? = nil
    var messageCount: Int? = nil
    var lastMessage: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isPinned = "is_pinned"
        case isArchived = "is_archived"
        case projectId = "project_id"
        case messageCount = "message_count"
        case lastMessage = "last_message"
    }
    
    var displayName: String {
        title ?? "New Chat"
    }
    
    var preview: String {
        lastMessage ?? "No messages"
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: String
    let role: Role
    let content: String
    let timestamp: Date
    var toolCalls: [ToolCall]?
    
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }
    
    enum CodingKeys: String, CodingKey {
        case id, role, content, timestamp
        case toolCalls = "tool_calls"
    }
}

struct ToolCall: Codable, Identifiable {
    let id: String
    let name: String
    let arguments: [String: AnyCodable]?
    let result: String?
    let status: Status
    
    enum Status: String, Codable {
        case pending
        case running
        case success
        case error
    }
}

struct AnyCodable: Codable {
    let value: Any
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else {
            value = try container.decode([String: AnyCodable].self)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let string = value as? String {
            try container.encode(string)
        } else if let int = value as? Int {
            try container.encode(int)
        } else if let double = value as? Double {
            try container.encode(double)
        } else if let bool = value as? Bool {
            try container.encode(bool)
        }
    }
}

struct MemoryEntry: Identifiable, Codable {
    let id: String
    let key: String
    let value: String
    let createdAt: Date
    let updatedAt: Date
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id, key, value, category
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Skill: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let content: String
    let version: Int
    let createdAt: Date
    let usageCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, content, version
        case createdAt = "created_at"
        case usageCount = "usage_count"
    }
}

struct Schedule: Identifiable, Codable {
    let id: String
    let name: String
    let prompt: String
    let schedule: String
    let enabled: Bool
    let lastRun: Date?
    let nextRun: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, prompt, schedule, enabled
        case lastRun = "last_run"
        case nextRun = "next_run"
    }
}
