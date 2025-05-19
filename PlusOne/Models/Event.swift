import Foundation

struct Event: Identifiable, Codable {
    let id = UUID()
    var name: String
    var count: Int
    var records: [CountRecord] = []
}

struct CountRecord: Identifiable, Codable {
    let id = UUID()
    var count: Int
    var timestamp: Date
    var note: String
    
    init(count: Int, timestamp: Date = Date(), note: String = "") {
        self.count = count
        self.timestamp = timestamp
        self.note = note.isEmpty ? "计数：\(count)" : note
    }
} 