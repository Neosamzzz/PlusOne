import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveEvents(_ events: [Event]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(events) {
            let url = getDocumentsDirectory().appendingPathComponent("events.json")
            try? encoded.write(to: url)
        }
    }
    
    func loadEvents() -> [Event] {
        let url = getDocumentsDirectory().appendingPathComponent("events.json")
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Event].self, from: data) {
                return decoded
            }
        }
        return []
    }
} 