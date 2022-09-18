import UIKit
import RealmSwift

class Progress: Object {
    @Persisted var objectID: ObjectId

    @Persisted var checkDate: Date
    @Persisted var progressCount: String

    convenience init(objectID: ObjectId, checkDate: Date, progressCount: String) {
        self.init()
        self.objectID = objectID
        self.checkDate = checkDate
        self.progressCount = progressCount
    }
}

