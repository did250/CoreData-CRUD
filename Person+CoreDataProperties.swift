//
//  Person+CoreDataProperties.swift
//  coretest
//
//  Created by 양희원 on 2022/09/13.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var id: Int16

}

extension Person : Identifiable {

}
