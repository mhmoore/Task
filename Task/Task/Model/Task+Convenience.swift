//
//  Task+Convenience.swift
//  Task
//
//  Created by Michael Moore on 8/7/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    
    convenience init(name: String, notes: String, isComplete: Bool, due: Date, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}

