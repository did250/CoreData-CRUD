import UIKit
import CoreData

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Manager.init()
        Manager.shared.createPerson(name: "JOHN", phone: "010-1234-5678", id: 2022)
        print(Manager.shared.fetchperson())
        Manager.shared.updatePerson(target: "JOHN", newphone: "010-1111-2222")
        print(Manager.shared.fetchperson())
        Manager.shared.createPerson(name: "KIM", phone: "010-9999-9999", id: 2021)
        print(Manager.shared.fetchperson())
        Manager.shared.deletePerson(target: "JOHN")
        print(Manager.shared.fetchperson())
    }
}
struct person {
    var name : String
    var phone : String
    var id : Int16
    
}

class Manager {
    static var shared: Manager = Manager()
    
    lazy var persistentContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name : "coretest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}
extension Manager {
    func createPerson ( name: String, phone: String, id: Int16 ){
        let new = Person(context: context)
        new.name = name
        new.phone = phone
        new.id = id
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchperson() -> [person] {
        var list = [person]()
        let request = NSFetchRequest<NSManagedObject>(entityName: "Person")
        let data = try! context.fetch(request)
        for i in data {
            let name = i.value(forKey: "name") as! String
            let phone = i.value(forKey: "phone") as! String
            let id = i.value(forKey: "id") as! Int16
            list.append(person(name: name, phone: phone, id: id))
        }
        return list
    }

    func updatePerson(target: String, newphone: String) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Person")
        request.predicate = NSPredicate(format: "name = %@", target)
        do {
            let data = try context.fetch(request)
            // target이 data에 있는지 체크
            if !data.isEmpty {
                let updated = data[0] as! NSManagedObject
                updated.setValue(newphone, forKey: "phone")
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        } catch { print(error) }
    }
    
    func deletePerson(target: String) {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Person")
        request.predicate = NSPredicate(format: "name = %@", target)
        do {
            let data = try context.fetch(request)
// 모든 target 삭제
            for i in data {
                let deleted = i as! NSManagedObject
                context.delete(deleted)
            }
// 0번째 target 만 삭제
//            let deleted = data[0] as! NSManagedObject
//            context.delete(deleted)
            do {
                try context.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
