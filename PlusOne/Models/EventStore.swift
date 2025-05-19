import Foundation
import SwiftUI

class EventStore: ObservableObject {
    static let shared = EventStore()
    
    @Published var events: [Event] = []
    
    private init() {
        loadEvents()
    }
    
    func loadEvents() {
        events = DataManager.shared.loadEvents()
    }
    
    func saveEvents() {
        DataManager.shared.saveEvents(events)
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
        }
    }
    
    func addRecord(to eventId: UUID, record: CountRecord) {
        if let index = events.firstIndex(where: { $0.id == eventId }) {
            events[index].records.append(record)
            saveEvents()
        }
    }
    
    func removeRecords(from eventId: UUID, recordIds: Set<UUID>) {
        if let index = events.firstIndex(where: { $0.id == eventId }) {
            events[index].records.removeAll { recordIds.contains($0.id) }
            saveEvents()
        }
    }
    
    func updateRecord(in eventId: UUID, recordId: UUID, timestamp: Date? = nil, note: String? = nil) {
        if let eventIndex = events.firstIndex(where: { $0.id == eventId }),
           let recordIndex = events[eventIndex].records.firstIndex(where: { $0.id == recordId }) {
            if let timestamp = timestamp {
                events[eventIndex].records[recordIndex].timestamp = timestamp
            }
            if let note = note {
                events[eventIndex].records[recordIndex].note = note
            }
            saveEvents()
        }
    }
} 