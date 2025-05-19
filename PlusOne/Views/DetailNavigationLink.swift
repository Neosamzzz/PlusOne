import SwiftUI

struct DetailNavigationLink: View {
    var selectedEvent: Event?
    @Binding var isActive: Bool

    var body: some View {
        Group {
            if let event = selectedEvent {
                NavigationLink(
                    destination: EventDetailView(event: event, onBack: { isActive = false }),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
} 