//
//  ContactInfo+CoreDataProperties.swift
//  CoreDataEx
//
//  Created by hw on 26/08/2019.
//  Copyright © 2019 hwj. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactInfo> {
        return NSFetchRequest<ContactInfo>(entityName: "ContactInfo")
    }

    @NSManaged public var type: String?
    @NSManaged public var contact: String?
    @NSManaged public var person: Person?

}
