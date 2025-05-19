import SwiftUI

struct EventDetailWrapper: View {
    let event: Event?
    let onBack: () -> Void

    var body: some View {
        if let event = event {
            EventDetailView(event: event, onBack: onBack)
        } else {
            Text("无效事件")
                .onAppear {
                    onBack()
                }
        }
    }
} 