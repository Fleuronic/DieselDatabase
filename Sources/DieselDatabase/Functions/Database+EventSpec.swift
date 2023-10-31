// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Event
import struct Diesel.Show
import struct Diesel.Location
import struct DieselService.EventBaseFields
import struct DieselService.EventListFields
import struct DieselService.EventDetailsFields
import struct DieselService.VenueBaseFields
import struct DieselService.AddressBaseFields
import struct DieselService.LocationBaseFields
import struct DieselService.ShowBaseFields
import protocol DieselService.EventSpec
import protocol Catenoid.Database

extension Database: EventSpec {
	public func listEvents(for year: Int) -> AsyncStream<Self.Result<[EventListFields]>> {
		.init {
			await fetch(EventListFields.self, where: Event.takesPlace(in: year))
		}
	}

	public func fetchEventDetails(with id: Event.ID) -> AsyncStream<Self.Result<EventDetailsFields?>> {
		.init {
			await fetch(EventDetailsFields.self, with: id)
		}
	}

	public func storeEvents(from list: [EventBaseFields], for year: Int) async -> Self.Result<[Event.ID]> {
		await deleteEvents(for: year).asyncFlatMap { _ in
			await list.asyncFlatMap { fields in
				let location = Location.Identified(
					fields: await fetch(LocationBaseFields.self, with: fields.locationID).value!
				)
				
				let show = await fields.showID.asyncMap { id in
					Show.Identified(
						fields: await fetch(ShowBaseFields.self, with: id).value!
					)
				}
				
				return await insert(
					Event.Identified(
						fields: fields,
						show: show,
						location: location,
						venue: fields.venueID.asyncMap { id in
							let venueFields = await fetch(VenueBaseFields.self, with: id).value!
							
							return .init(
								fields: venueFields,
								address: .init(
									fields: await fetch(AddressBaseFields.self, with: venueFields.addressID).value!,
									location: location
								)
							)
						}
					)
				)
			}
		}
	}

	public func deleteEvents(for year: Int) async -> Self.Result<[Event.ID]> {
		await delete(Event.Identified.self)
	}
}
