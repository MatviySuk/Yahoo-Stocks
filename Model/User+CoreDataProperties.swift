//
//  User+CoreDataProperties.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 18.07.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var choosenStocks: [String]?
    @NSManaged public var savedStocks: Array<CStock>?
    
//    [CStock]?

}

extension User : Identifiable {

}
