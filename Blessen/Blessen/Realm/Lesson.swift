import UIKit
import RealmSwift

class Lesson: Object {
    @Persisted var objectID: ObjectId

    @Persisted var lessonFee: String
    @Persisted var lessonCount: String
    @Persisted var totalCount: String
    @Persisted var startDate: Date

    convenience init(objectID: ObjectId, lessonFee: String, totalCount: String, startDay: Date) {
        self.init()
        self.objectID = objectID
        self.lessonFee = lessonFee
        self.totalCount = totalCount
    }
}

