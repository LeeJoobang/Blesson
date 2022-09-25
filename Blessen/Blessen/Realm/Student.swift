import UIKit
import RealmSwift

class Student: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId 

    @Persisted var name: String
    @Persisted var address: String
    @Persisted var phoneNumber: String
    @Persisted var image: String?

    convenience init(name: String, address: String, phoneNumber: String, image: String?) {
        self.init()
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.image = image
    }
}

