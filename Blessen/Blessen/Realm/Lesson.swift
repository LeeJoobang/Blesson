import UIKit
import RealmSwift

class Lesson: Object {

    @Persisted(primaryKey: true) var objectID: ObjectId
    
    @Persisted var foreignID: ObjectId
    @Persisted var lessonFee: String
    @Persisted var lessonCount: Int
    @Persisted var totalCount: String
    @Persisted var startDate: String

    convenience init(foreignID: ObjectId, lessonFee: String, totalCount: String, startDate: String) {
        self.init()
        self.foreignID = foreignID
        self.lessonCount = 0
        self.lessonFee = lessonFee
        self.totalCount = totalCount
        self.startDate = startDate
    }
    
    convenience init(foreignID: ObjectId, lessonCount: Int) {
        self.init()
        self.foreignID = foreignID
        self.lessonCount = lessonCount
    }
}

