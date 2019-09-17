//
//  Person+CoreDataProperties.swift
//  CoreDataEx
//
//  Created by hw on 26/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for contacts
extension Person {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: ContactInfo)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: ContactInfo)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}
