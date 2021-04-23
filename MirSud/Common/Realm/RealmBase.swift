import Foundation
import RealmSwift

class RealmBase: Object {
    
    @objc dynamic var id: Int = 0
    
    func getId()->Int{
        return id
    }
   
    override static func primaryKey() -> String? {
        return "id"
    }
}
