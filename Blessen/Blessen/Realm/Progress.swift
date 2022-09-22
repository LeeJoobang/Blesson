import UIKit
import RealmSwift

class Progress: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId

    @Persisted var foreignID: ObjectId
    @Persisted var checkDate: String
    @Persisted var progressCount: Int

    convenience init(foreignID: ObjectId, checkDate: String, progressCount: Int) {
        self.init()
        self.foreignID = foreignID
        self.checkDate = checkDate
        self.progressCount = 0
    }
}

