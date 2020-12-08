//
//  TripService.swift
//  Resfeber
//
//  Created by Joshua Rutkowski on 12/4/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation
import CoreData

public final class TripService {
    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    var coreDataStack = CoreDataStack.sharedCoreDataStack
    private(set) var searchTrips = [Trip]()
    
    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Public
extension TripService {
    @discardableResult
    public func addTrip(name: String, image: Data?, startDate: Date?, endDate: Date? ) -> Trip {
        let trip = Trip(context: managedObjectContext)
        trip.name = name
        trip.image = image
        trip.startDate = startDate
        trip.endDate = endDate
        
        coreDataStack.saveContext(managedObjectContext)
        return trip
    }
    
    public func getTrips() -> [Trip]? {
        let tripFetch: NSFetchRequest<Trip> = Trip.fetchRequest()
        
        do {
            let results = try managedObjectContext.fetch(tripFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    @discardableResult
    public func updateTrip(_ trip: Trip) -> Trip {
        coreDataStack.saveContext(managedObjectContext)
        return trip
    }
    
    public func deleteTrip(_ trip: Trip) {
        managedObjectContext.delete(trip)
        coreDataStack.saveContext(managedObjectContext)
    }
    
    @discardableResult
    public func addEvent(name: String, eventDescription: String?, category: String?, latitude: Double?, longitude: Double?, startDate: Date?, endDate: Date?, notes: String?, trip: Trip) -> Event {
        let event = Event(context: managedObjectContext)
        event.name = name
        event.eventDescription = eventDescription
        event.category = category
        event.latitude = latitude ?? 0.0
        event.longitude = longitude ?? 0.0
        event.startDate = startDate
        event.endDate = endDate
        event.notes = notes
        event.trip = trip
        
        coreDataStack.saveContext(managedObjectContext)
        return event
    }
    
    public func getEvents() -> [Event]? {
        let eventFetch: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            let results = try managedObjectContext.fetch(eventFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    @discardableResult
    public func updateEvent(_ event: Event) -> Event {
        coreDataStack.saveContext(managedObjectContext)
        return event
    }
    
    public func deleteEvent(_ event: Event) {
        managedObjectContext.delete(event)
        coreDataStack.saveContext(managedObjectContext)
    }
}

