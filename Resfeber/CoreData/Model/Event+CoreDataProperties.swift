//
//  Event+CoreDataProperties.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var category: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var eventDescription: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var trip: Trip?

}

extension Event : Identifiable {

}