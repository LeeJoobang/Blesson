import UIKit
import RealmSwift

class Lesson: Object {
    @Persisted var objectID: ObjectId

    @Persisted var lessonFee: String
    @Persisted var lessonCount: String
    @Persisted var totalCount: String
    @Persisted var startDate: String

    convenience init(objectID: ObjectId, lessonFee: String, totalCount: String, startDate: String) {
        self.init()
        self.objectID = objectID
        self.lessonFee = lessonFee
        self.totalCount = totalCount
        self.startDate = startDate
    }
    
    convenience init(objectID: ObjectId, lessonCount: String) {
        self.init()
        self.objectID = objectID
        self.lessonCount = lessonCount
    }
}

