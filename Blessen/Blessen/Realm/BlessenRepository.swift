import Foundation
import RealmSwift

fileprivate protocol BlessenRepositoryType: AnyObject {
    func fetch() -> Results<MessageList>
    func fetchSort(_ sort: String) -> Results<MessageList>
    func fetchFilter() -> Results<MessageList>
    func updateCheck(item: MessageList)
    func deleteItem(item: MessageList)
}

final class BlessenRepository: BlessenRepositoryType {
    
    let localRealm = try! Realm()
    
    func fetch() -> Results<MessageList> {
        return localRealm.objects(MessageList.self).sorted(byKeyPath: "content", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<MessageList> {
        return localRealm.objects(MessageList.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<MessageList> {
        return localRealm.objects(MessageList.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    func updateCheck(item: MessageList){
        try! localRealm.write {
            item.check.toggle()
            print("realm update succed, reload Rows 필요")
        }
    }
    
    func deleteData(data: MessageList){
        try! localRealm.write{
            localRealm.delete(data)
        }
    }
    
    func deleteItem(item: MessageList){
        try! localRealm.write{
            localRealm.delete(item)
        }
        removeImageFromDocument(filename: "\(item.objectID).jpg")
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
    
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    
    
}
