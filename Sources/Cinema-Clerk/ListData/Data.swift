import Foundation
import Sword
//let persistentLists: [String] = load("")

//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//
//}

func loadFromJSON() -> [UInt64:DiscordClerk]? {
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("managerSave.json")
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([UInt64:DiscordClerk].self, from: data)
    } catch {
        return nil
    }
}

func saveToJSON(_ object: [UInt64:DiscordClerk]) {
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("managerSave.json")
        let encoder = try JSONEncoder().encode(object)
        try encoder.write(to: fileURL)
    } catch {
        print("JSONSave error of \(error)")
    }
}
