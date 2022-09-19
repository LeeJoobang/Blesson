import UIKit
import RealmSwift

class MessageList: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId

    @Persisted var check: Bool // 즐겨찾기(필수)
    @Persisted var content: String // 내용(필수)
    
    convenience init(content: String) {
        self.init()
        self.check = false
        self.content = content
    }
}

