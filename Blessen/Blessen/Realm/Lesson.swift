import UIKit
import RealmSwift

class Lesson: Object {

    @Persisted(primaryKey: true) var objectID: ObjectId
    
    @Persisted var foreignID: ObjectId
    @Persisted var lessonFee: String
    @Persisted var lessonCount: String
    @Persisted var totalCount: Int
    @Persisted var startDate: String
    

    convenience init(foreignID: ObjectId, lessonFee: String, startDate: String, lessonCount: String) {
        self.init()
        self.foreignID = foreignID
        self.lessonCount = lessonCount
        self.lessonFee = lessonFee
        self.totalCount = 0
        self.startDate = startDate
    }
}

