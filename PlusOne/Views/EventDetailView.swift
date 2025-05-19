import SwiftUI

struct EventDetailView: View {
    let event: Event
    var onBack: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // 只显示大号计数数字
            Text("\(event.count)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .navigationTitle(event.name.isEmpty ? "详情" : event.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: Event(name: "测试事件", count: 42))
    }
} 
