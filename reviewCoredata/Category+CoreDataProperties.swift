//
//  Category+CoreDataProperties.swift
//  reviewCoredata
//
//  Created by yuka on 2018/02/19.
//  Copyright © 2018年 yuka. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var titleOfCat: String?
    @NSManaged public var catIDDate: NSDate?
    @NSManaged public var todos: NSSet?

}

// MARK: Generated accessors for todos
extension Category {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
