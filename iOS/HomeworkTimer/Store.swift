import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Session] = []
    @Published var isPro: Bool = false

    static let freeLimit = 200

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("homeworktimer_items.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func add(_ item: Session) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Session) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Session) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Session].self, from: data) else {
            items = [
        Session(subject: "Sample Subject 1", childName: "Sample Childname 1", minutes: 5.0, date: Calendar.current.date(byAdding: .day, value: -0, to: Date()) ?? Date(), notes: "Sample Notes 1"),
        Session(subject: "Sample Subject 2", childName: "Sample Childname 2", minutes: 10.0, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), notes: "Sample Notes 2"),
        Session(subject: "Sample Subject 3", childName: "Sample Childname 3", minutes: 15.0, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), notes: "Sample Notes 3")
            ]
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
