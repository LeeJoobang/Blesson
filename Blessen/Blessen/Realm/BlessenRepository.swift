import Foundation
import RealmSwift

protocol BlessenRepositoryType {
    func fetch() -> Results<MessageList>
    func fetchSort(_ sort: String) -> Results<MessageList>
    func fetchFilter() -> Results<MessageList>
    func updateCheck(item: MessageList)
    func deleteItem(item: MessageList)
}

class BlessenRepository: BlessenRepositoryType {
    
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
        removeImageFromDocument(filename: "\(item.objectID).jpg") // filemanager에 있는 애를 데려옴.
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // document 경로를 가져올 수 있따.
        // ex) file:///Users/joobanglee/Library/Developer/CoreSimulator/Devices/EE7FB4FC-8C3C-477D-BE12-92617771247F/data/Containers/Data/Application/1A88C18A-E6C7-41A1-800C-0A5E2419A6C8/Documents/ 여기까지 보여준당
        let fileURL = documentDirectory.appendingPathComponent(filename)
    
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    
    
}
