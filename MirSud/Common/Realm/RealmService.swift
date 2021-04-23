import Foundation
import RealmSwift

class RealmService {
    
    enum RealmConfigEnum {
        
        case unsafe
        case safe
        

        private static let mainConfig = Realm.Configuration (
            fileURL:  getRealmURL(dbName: "main"),
            deleteRealmIfMigrationNeeded: true
        )
        
        var config: Realm.Configuration {
            switch self {
            default:
                return RealmConfigEnum.mainConfig
            }
        }
        
        static func getRealmURL(dbName: String) -> URL {
           let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                                appropriateFor: nil, create: false)
           return documentDirectory.appendingPathComponent("\(dbName).realm")
        }
    }

    
    //MARK:- private >>>
    
    internal static func getInstance(_ confEnum: RealmConfigEnum) -> Realm? {
        do {
            let realm = try Realm(configuration: confEnum.config)
          //  print("Realm DB Path: \(realm.configuration.fileURL?.absoluteString ?? "")")
            return realm
        } catch(let err) {
            print(err.localizedDescription)
        }
        return nil
    }
    
    
    internal static func save<T: Object>(items: [T], update: Bool) {
        let realm = getInstance(.unsafe)
        do {
            try realm?.write {
                if update {
                    realm?.add(items, update: .all)
                } else {
                    realm?.add(items)
                }
            }
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    

    internal static func delete(confEnum: RealmConfigEnum, clazz: Object.Type, id: Int? = nil) {
        let realm = getInstance(confEnum)
        do {
            try realm?.write {
                // by id
                if let _id = id {
                    if let results = realm?.objects(clazz.self).filter("id == %@", _id) {
                        for result in results {
                            realm?.delete(result)
                        }
                    }
                } else {
                    if let results = realm?.objects(clazz.self) {
                        for result in results {
                            realm?.delete(result)
                        }
                    }
                }
            }
        } catch(let err) {
            print(err.localizedDescription)
        }
    }
    
    
    
    internal static func clearAll(confEnum: RealmConfigEnum) {
        let realm = getInstance(confEnum)
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch(let err) {
            print(err.localizedDescription)
        }
    }

}
