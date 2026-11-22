import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 12
    
    init(cornerRadius: CGFloat = 12, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        content
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .glassEffect()
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
            }
    }
}

struct GlassToolbar<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .glassEffect()
    }
}

struct PulsingDot: View {
    let color: Color
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear { isAnimating = true }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String?
    
    init(icon: String, title: String, subtitle: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorBanner: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.hermesRed)
            Text(message)
                .font(.caption)
            Spacer()
        }
        .padding(8)
        .background(Color.hermesRed.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
