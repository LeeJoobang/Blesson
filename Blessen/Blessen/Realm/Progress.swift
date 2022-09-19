import UIKit
import RealmSwift

class Progress: Object {

    @Persisted(primaryKey: true) var objectID: ObjectId

    @Persisted var foreignID: ObjectId
    @Persisted var checkDate: Date
    @Persisted var progressCount: String

    convenience init(foreignID: ObjectId, checkDate: Date, progressCount: String) {
        self.init()
        self.foreignID = foreignID
        self.checkDate = checkDate
        self.progressCount = progressCount
    }
}

