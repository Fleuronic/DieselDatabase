// Copyright © Fleuronic LLC. All rights reserved.

import PersistDB

import struct Diesel.Event
import struct Diesel.Show
import struct Diesel.Venue
import struct Diesel.Address
import struct Diesel.Location
import protocol Schemata.AnyModel
import protocol Catenoid.Database

public struct Database {
	public private(set) var store: Store<ReadWrite>

	public init() async {
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
