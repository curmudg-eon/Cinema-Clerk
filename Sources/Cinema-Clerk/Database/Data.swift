import Foundation
import Sword

import SQLite
import SQLite3

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

func loadPicks(id: UInt64) -> [WatchPick]? {
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(id)Picks.json")
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([WatchPick].self, from: data)
    } catch {
        return nil
    }
}

func savePicks(id: UInt64, _ object: [WatchPick]) {
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("\(id)Picks.json")
        let encoder = try JSONEncoder().encode(object)
        try encoder.write(to: fileURL)
    } catch {
        print("JSONSave error of \(error)")
    }
}

//func buildDatabase() -> Connection {
//    let db = try Connection("./db.sqlite3")
//    let
//
//
//    return db
//}

//func createDB() throws -> Connection {
//    let db = try Connection("./db.sqlite3")
//    let clerks = Table("clerks"), movieLists = Table("movieLists"), watchPicks = Table("watchPicks")
//    let id = Expression<String>("id"), key = Expression<Int>("key"), ownerID = Expression<String>("ownerID"), listName = Expression<String>("listName"), pickName = Expression<String>("pickName"), pickLink = Expression<String>("pickLink"), pickSubmitter = Expression<String>("pickSubmitter")
//
//    try db.run(clerks.create(ifNotExists: true) { t in
//        t.column(id, primaryKey: true)
//    })
//    try db.run(movieLists.create(ifNotExists: true) { t in
//        t.column(key, primaryKey: .autoincrement) // just scale them so they have primary keys to reference them 3NF baybe
//        t.column(ownerID)
//        t.column(listName)
//    })
//    try db.run(watchPicks.create(ifNotExists: true) { t in
//        t.column(key, primaryKey: .autoincrement)
//        t.column(ownerID)
//        t.column(pickName)
//        t.column(pickLink)
//        t.column(pickName)
//    })
//
//
//    return db
//}
//func addListToDB(name: String, owner: UInt64) throws -> Int {
//    let rowid = try db.run(movieLists.insert(listName <- name, ownerID <- owner))
//    return 0
//}

//*************************** MUST MAKE PROPER CATCHES BEFORE DEPLOYMENT *****************************************
class Database {
    let db: Connection
    let clerks = Table("clerks"), movieLists = Table("movieLists"), watchPicks = Table("watchPicks")
    let id = Expression<String>("id"), key = Expression<Int>("key"), ownerID = Expression<String>("ownerID"), listName = Expression<String>("listName"), pickName = Expression<String>("pickName"), pickLink = Expression<String>("pickLink"), pickSubmitter = Expression<String>("pickSubmitter")
    
    init() {
        db = try! Connection("./db.sqlite3")
            
        try! db.run(clerks.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
        })
        try! db.run(movieLists.create(ifNotExists: true) { t in
            t.column(key, primaryKey: .autoincrement) // just scale them so they have primary keys to reference them 3NF baybe
            t.column(ownerID)
            t.column(listName)
        })
        try! db.run(watchPicks.create(ifNotExists: true) { t in
            t.column(key, primaryKey: .autoincrement)
            t.column(ownerID)
            t.column(pickName)
            t.column(pickLink)
            t.column(pickName)
        })
    }
    ///Adds a movieList to the database and then returns the primary key of the database
    func addListToDB(name: String, owner: UInt64) throws -> Int {
        let row = try! db.run(movieLists.insert(listName <- name, ownerID <- String(owner)))
        let rowKey: Int = try! db.prepare(movieLists.select(key).filter(rowid == row))
        return 0
    }

    
}


//https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#swift-package-manager 
// I gotta draw out how I'm going to do this.
//Right now I have a dictionary of type UInt64:DiscordClerk which references servers by their Snowflake rawvalue
//Each object owns a dictionary of type String:[MoviePick] that holds it's lists
//Each movie pick contains data
