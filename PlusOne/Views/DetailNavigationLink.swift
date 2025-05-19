import SwiftUI

struct DetailNavigationLink: View {
    var selectedEventId: UUID?
    @Binding var isActive: Bool

    var body: some View {
        Group {
            if let eventId = selectedEventId {
                NavigationLink(
                    destination: EventDetailView(eventId: eventId, onBack: { isActive = false }),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
} 