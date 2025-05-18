import Foundation

struct Event: Identifiable, Codable {
    let id = UUID()
    var name: String
    var count: Int
} 