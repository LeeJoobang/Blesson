import UIKit
import RealmSwift

class Progress: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId

    @Persisted var foreignID: ObjectId
    @Persisted var checkDate: List<String> //check한 데이트에 정보 저장
    @Persisted var progressCount: Int
    
    var checkDateArr: [String]{
        get {
            return checkDate.map{ $0 }
        } set {
            checkDate.removeAll()
            checkDate.append(objectsIn: newValue)
        }
    }

    convenience init(foreignID: ObjectId, progressCount: Int) {
        self.init()
        self.foreignID = foreignID
        self.progressCount = 0
    }
}

