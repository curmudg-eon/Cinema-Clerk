import Foundation
import Sword

import SQLite
import SQLite3

//*************************** MUST MAKE PROPER CATCHES BEFORE DEPLOYMENT *****************************************
class Database {
    let db: Connection
    let clerks = Table("clerks"), movieLists = Table("movieLists"), watchPicks = Table("watchPicks")
    let id = Expression<String>("id"), key = Expression<Int>("key"), ownerID = Expression<String>("ownerID"), listName = Expression<String>("listName"), pickName = Expression<String>("pickName"), pickLink = Expression<String>("pickLink"), pickSubmitter = Expression<String>("pickSubmitter")
    
    // MARK: INIT
    init(dbFile: String = "./db.sqlite3") {
        do {
            db = try Connection(dbFile)
        } catch {
            print("Failed to initialized dabatase. Error: \(error)")
            db = try! Connection()
        }
        
        try! db.run(clerks.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true) ///String instead of Int because snowflake rawvalues may be too large for DB ints if I remember correctly
            //Later there will be data referencing the categories and channels of certain clerks
        })
        try! db.run(movieLists.create(ifNotExists: true) { t in
            t.column(key, primaryKey: .autoincrement) // just scale them so they have primary keys to reference them 3NF baybe
            t.column(ownerID)
            t.column(listName)
            //Maybe make a constraint that does not let 2 entries with the same ownerID have the same name. This currently shouldn't be possible though.
        })
        try! db.run(watchPicks.create(ifNotExists: true) { t in
            t.column(key, primaryKey: .autoincrement)
            t.column(ownerID)
            t.column(pickName)
            t.column(pickLink)
            t.column(pickSubmitter)
            //            t.foreignKey(ownerID, references: movieLists, key, update: .noAction, delete: .noAction)
            //            t.foreignKey(ownerID, references: movieLists, key, update: .noAction, delete: .setNull)
        })
    }
    
    // MARK: ADDERS
    ///Adds an entry to the Clerk table and returns the rowid of the entry
    func addClerkToDB(snowflakeID: UInt64) throws -> Int? {
        do {
            return Int(try db.scalar(clerks.select(rowid).where(rowid == db.run(clerks.insert(id <- String(snowflakeID)))).order(key.desc).limit(1)))
        } catch {
            print("Failure to add clerk \(snowflakeID) to database. \n Error: \(error)")
            return nil
        }
    }
    ///Adds an entry to the movieList table and returns the primary key of the entry
    func addListToDB(name: String, owner: UInt64) throws -> Int {
        //        try! db.run(movieLists.insert(listName <- name, ownerID <- String(owner)))
        return Int(try! db.scalar(movieLists.select(key).where(rowid == db.run(movieLists.insert(listName <- name, ownerID <- String(owner)))).order(key.desc).limit(1)))
    }
    ///Adds an entry to the watchList table and returns the primary key of the entry
    func addPickToDB(owner: UInt64, name: String, link: String, submitter: String) throws -> Int {
        return Int(try! db.scalar(watchPicks.select(key).where(rowid == db.run(watchPicks.insert(ownerID <- String(owner), pickName <- name, pickLink <- link, pickSubmitter <- submitter))).order(key.desc).limit(1)))
    }
    
    
    
    // MARK: GETTERS
    
    //Add later
        //    func getClerk(snowflakeID: UInt64) -> DiscordClerk {
        //
        //    }
    
    ///Get full list of clerks if needed
    func getClerkList() throws -> [UInt64:DiscordClerk] {
        var list: [UInt64:DiscordClerk] = [:]
        for clerk in try db.prepare(clerks.select(id)) {
            do {
                //list.insert(try UInt64(clerk.get(id))!) //for getting a set
                list[try UInt64(clerk.get(id))!] = DiscordClerk(snowflakeID: UInt64(try clerk.get(id))!)
            } catch {
                print("Failed to get clerkList from database. \nError: \(error)")
            }
        }
        return list
    }
    
    ///Return all movie list names and IDs given a clerk identifier
    func getAllMovieLists(forClerk clerkID: UInt64) throws -> [String:Int] {
        var returnList: [String:Int] = [:]
        do {
            for entry in try db.prepare(movieLists.select(listName, key).where(ownerID == String(clerkID)))  {
                returnList[entry[listName]] = entry[key]
            }
        } catch {
            print("Failed to get all movie lists. \nError: \(error)")
        }
        if returnList.isEmpty {
            returnList["voting"] = try addListToDB(name: "voting", owner: clerkID)
        }
        return returnList
    }
    
    ///Return all movie lists if necessary for some god forsaken reason
    func getFullMovieLists(forClerk clerkID: UInt64) throws -> [String:[WatchPick]] {
        var returnList: [String:[WatchPick]] = [:]
        do {
            for list in try db.prepare(movieLists.select(listName).where(ownerID == String(clerkID)))  {
                returnList[list[listName]] = try getMovieList(forList: UInt64(list[key]))
            }
        } catch {
            print("Failed to get all movie lists. \nError: \(error)")
        }
        return returnList
    }
    
    ///Code not complete - Return a [WatchPick]? from list primary key
    func getMovieList(forList listID: UInt64) throws -> [WatchPick]? {
        var returnList: [WatchPick] = [WatchPick]()
        do {
            for pick in try db.prepare(watchPicks.where(ownerID == String(listID))) {
                returnList.append(WatchPick(title: pick[pickName], link: pick[pickLink], submitter: pick[pickSubmitter], databasePK: pick[key]))
            }
        } catch {
            print("Failed to get movieList \"\(listID)\" from database. \nError: \(error)")
        }
        return returnList
    }
    
    ///Not tested **** this is not complete**** do not use
    func getMovieList(clerkID: UInt64, list: String) throws -> [WatchPick] {
        var returnList: [WatchPick] = [] ///Initiated as an empty list to be returned if nothing comes back from the DB
        do {
            if try db.scalar(clerks.filter(id == String(clerkID)).exists), try db.scalar(movieLists.filter(ownerID == String(clerkID) && listName == list).exists) { ///Check that the clerk exists and then the clerk has requested list
                let owner: Int = try Int(db.scalar(movieLists.select(key).where(ownerID == String(clerkID) && listName == list).limit(1))) //I feel I can do this more elegantly but what works works for now.
                for pick in try db.prepare(watchPicks.where(ownerID == String(owner))) {
                    returnList.append(WatchPick(title: pick[pickName], link: pick[pickLink], submitter: pick[pickSubmitter], databasePK: pick[key]))
                }
            }
        } catch {
            print("Failed to get movieList \"\(list)\" from database. \nError: \(error)")
        }
        return returnList
    }
    
//    func getWatchPick() {
//
//    }
    
}
