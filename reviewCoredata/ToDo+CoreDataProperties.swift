//
//  ToDo+CoreDataProperties.swift
//  reviewCoredata
//
//  Created by yuka on 2018/02/19.
//  Copyright © 2018年 yuka. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var catTitle: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var category: Category?

}
