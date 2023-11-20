// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import struct Diesel.Event
import struct Diesel.Show
import struct Diesel.Venue
import struct Diesel.Address
import struct Diesel.Location
import struct Catena.IDFields
import protocol Schemata.AnyModel
import protocol Catenoid.Database
import protocol DieselService.EventFields

public struct Database<
	EventListFields: EventFields,
	EventDetailsFields: EventFields
>{
	public private(set) var store: Store<ReadWrite>

	public init(
		eventListFields: EventListFields.Type = IDFields<Event.Identified>.self,
		eventDetailsFields: EventDetailsFields.Type = IDFields<Event.Identified>.self
	) async {
		store = try! await Self.createStore()
	}
}

// MARK: -
extension Database: Catenoid.Database {
	public static var types: [AnyModel.Type] {
		[
			Event.Identified.self,
			Show.Identified.self,
			Venue.Identified.self,
			Address.Identified.self,
			Location.Identified.self
		]
	}

	public mutating func clear() async throws {
		try Store.destroy()
		store = try await Self.createStore()
	}
}
