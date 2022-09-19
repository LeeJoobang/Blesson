import UIKit
import RealmSwift

class Student: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId 

    @Persisted var name: String
    @Persisted var address: String
    @Persisted var phoneNumber: String

    convenience init(name: String, address: String, phoneNumber: String) {
        self.init()
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
    }
}

