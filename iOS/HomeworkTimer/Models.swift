import Foundation

struct Session: Identifiable, Codable, Equatable {
    let id: UUID
    var subject: String
    var childName: String
    var minutes: Double
    var date: Date
    var notes: String

    init(id: UUID = UUID(), subject: String = "", childName: String = "", minutes: Double = 0, date: Date = Date(), notes: String = "") {
        self.id = id
        self.subject = subject
        self.childName = childName
        self.minutes = minutes
        self.date = date
        self.notes = notes
    }
}
