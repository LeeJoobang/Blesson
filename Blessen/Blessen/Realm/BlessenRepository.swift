import Foundation
import RealmSwift

fileprivate protocol MessageRepositoryType: AnyObject {
    func fetch() -> Results<MessageList>
    func fetchSort(_ sort: String) -> Results<MessageList>
    func fetchFilter() -> Results<MessageList>
    func updateCheck(item: MessageList)
    func deleteData(data: MessageList)
}

fileprivate protocol StudentRepositoryType: AnyObject {
    func fetch() -> Results<Student>
    func fetchSort(_ sort: String) -> Results<Student>
    func fetchFilter() -> Results<Student>
    func updateCheck(item: Student)
    func deleteData(data: Student)
}

fileprivate protocol LessonRepositoryType: AnyObject {
    func fetch() -> Results<Lesson>
    func fetchSort(_ sort: String) -> Results<Lesson>
    func fetchFilter() -> Results<Lesson>
    func updateCheck(item: Lesson)
    func deleteData(data: Lesson)
}

fileprivate protocol ProgressRepositoryType: AnyObject {
    func fetch() -> Results<Progress>
    func fetchSort(_ sort: String) -> Results<Progress>
    func fetchFilter() -> Results<Progress>
    func updateCheck(item: Progress)
    func deleteData(data: Progress)
}

final class MessageRepository: MessageRepositoryType {
    
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
    
    func falseCheck(item: MessageList){
        try! localRealm.write {
            item.check = false
            print("item을 false로 변환함")
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

final class StudentRepository: StudentRepositoryType {
      
    let localRealm = try! Realm()
    
    func fetch() -> Results<Student> {
        return localRealm.objects(Student.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<Student> {
        return localRealm.objects(Student.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<Student> {
        return localRealm.objects(Student.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    func updateCheck(item: Student) {
        try! localRealm.write {
//            item..toggle()
            print("realm update succed, reload Rows 필요")
        }
    }
        
    func deleteData(data: Student){
        try! localRealm.write{
            localRealm.delete(data)
        }
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

final class LessonRepository: LessonRepositoryType {
      let localRealm = try! Realm()
    
    func fetch() -> Results<Lesson> {
        return localRealm.objects(Lesson.self).sorted(byKeyPath: "foreignID", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<Lesson> {
        return localRealm.objects(Lesson.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<Lesson> {
        return localRealm.objects(Lesson.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    func updateCheck(item: Lesson) {
        try! localRealm.write {
//            item..toggle()
            print("realm update succed, reload Rows 필요")
        }
    }
        
    func deleteData(data: Lesson){
        try! localRealm.write{
            localRealm.delete(data)
        }
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

final class ProgressRepository: ProgressRepositoryType {
      let localRealm = try! Realm()
    
    func fetch() -> Results<Progress> {
        return localRealm.objects(Progress.self).sorted(byKeyPath: "foreignID", ascending: true)
    }
    
    func fetchSort(_ sort: String) -> Results<Progress> {
        return localRealm.objects(Progress.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<Progress> {
        return localRealm.objects(Progress.self).filter("diaryTitle CONTAINS[c] 'a'")
    }
    
    func updateCheck(item: Progress) {
        try! localRealm.write {
//            item..toggle()
            print("realm update succed, reload Rows 필요")
        }
    }
        
    func deleteData(data: Progress){
        try! localRealm.write{
            localRealm.delete(data)
        }
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
