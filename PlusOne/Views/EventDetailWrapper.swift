import SwiftUI

struct EventDetailWrapper: View {
    let eventId: UUID?
    let onBack: () -> Void

    var body: some View {
        if let eventId = eventId {
            EventDetailView(eventId: eventId, onBack: onBack)
        } else {
            Text("无效事件")
                .onAppear {
                    onBack()
                }
        }
    }
} 