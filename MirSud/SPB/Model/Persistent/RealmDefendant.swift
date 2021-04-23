import Foundation
import RealmSwift

class RealmDefendant: RealmBase {
    @objc dynamic var firstName: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var middleName: String = ""
    @objc dynamic var lastActivityDate: String = ""
    @objc dynamic var status: String = "" //Defendant.Status
    @objc dynamic var vkID: String = ""
    @objc dynamic var okID: String = ""
    @objc dynamic var telegramID: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var email: String = ""
    var vkUsers = List<RealmVkUser>()
    var cases = List<RealmCivilCase>()
}

