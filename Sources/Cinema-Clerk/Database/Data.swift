import Foundation
import Sword

import SQLite
import SQLite3

//*************************** MUST MAKE PROPER CATCHES BEFORE DEPLOYMENT *****************************************
class Database {
    let db: Connection
    let clerks = Table("clerks"), movieLists = Table("movieLists"), watchPicks = Table("watchPicks")
    let id = Expression<String>("id"), key = Expression<Int>("key"), ownerID = Expression<String>("ownerID"), listName = Expression<String>("listName"), pickName = Expression<String>("pickName"), pickLink = Expression<String>("pickLink"), pickSubmitter = Expression<String>("pickSubmitter")
    
    init() {
        db = try! Connection("./db.sqlite3")
        
        try! db.run(clerks.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            //Later there will be data referencing the categories and channels of certain clerks
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
            t.column(pickSubmitter)
            //            t.foreignKey(ownerID, references: movieLists, key, update: .noAction, delete: .noAction)
            //            t.foreignKey(ownerID, references: movieLists, key, update: .noAction, delete: .setNull)
        })
    }
    ///Adds an entry to the Clerk table and returns the rowid of the entry
    func addClerkToDB(snowflakeID: UInt64) throws -> Int {
        return Int(try! db.scalar(clerks.select(rowid).where(rowid == db.run(clerks.insert(id <- String(snowflakeID)))).order(key.desc).limit(1)))
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
    
    //Add later
    //    func getClerk(snowflakeID: UInt64) -> DiscordClerk {
    //
    //    }
    
    ///Get full list of clerks if needed
    func getClerkList() throws -> [UInt64:DiscordClerk]? {
        var list: [UInt64:DiscordClerk] = [:]
        for clerk in try db.prepare(clerks.select(id)) {
            do {
                list[try UInt64(clerk.get(id))!] = DiscordClerk(snowflakeID: UInt64(try clerk.get(id))!)
            } catch {
                print("Failed to get clerkList from database")
            }
        }
        return list
    }
    
    func getAllMovieLists(forClerk clerkID: UInt64) throws -> [String:[WatchPick]] {
        var returnList: [String:[WatchPick]] = [:]
        do {
            for list in try db.prepare(movieLists.select(listName).where(ownerID == String(clerkID)))  {
                returnList[list[listName]] = try getMovieList(forList: UInt64(list[key]))
            }
        } catch {

        }
        return returnList
    }
    
    //I'm not sure what I was doing with this
    ///Do not use.
    func getMovieList(forList listID: UInt64) throws -> [WatchPick]? {
        var returnList: [WatchPick] = [WatchPick]()
        do {
            for pick in try db.prepare(watchPicks.where(ownerID == String(listID))) {
                returnList.append(WatchPick(title: pick[pickName], link: pick[pickLink], submitter: pick[pickSubmitter], databasePK: pick[key]))
            }
        } catch {
            print("Faild to get movieList from database")
        }
        return returnList
    }
    
    ///Not tested **** this is not complete**** do not use
    func getMovieList(clerkID: UInt64, list: String) throws -> [WatchPick] {
        var returnList: [WatchPick] = [] ///Initiated as an empty list to be returned if nothing comes back from the DB
        do {
            if try db.scalar(clerks.filter(id == String(clerkID)).exists), let owner: Int = try db.scalar(movieLists.select(key).where(ownerID == String(clerkID) && listName == list)) { ///Check that the clerk exists and then the clerk has requested list
                for pick in try db.prepare(watchPicks.where(ownerID == String(owner))) {
                    returnList.append(WatchPick(title: pick[pickName], link: pick[pickLink], submitter: pick[pickSubmitter], databasePK: pick[key]))
                }
            }
        } catch {
            print("Faild to get movieList from database")
        }
        return returnList
    }
    
    func getWatchPick() {
        
    }
    
}
