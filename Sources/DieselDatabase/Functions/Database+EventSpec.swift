// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Event
import struct Diesel.Show
import struct Diesel.Location
import struct DieselService.EventBaseFields
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
				let showID = fields.show?.id
				let show = await showID.asyncMap { showID in
					Show.Identified(
						fields: await fetch(ShowBaseFields.self, with: showID).value!
					)
				}

				let venueID = fields.venue?.id
				let locationID = fields.location.id
				let location = Location.Identified(
					fields: await fetch(LocationBaseFields.self, with: locationID).value!
				)

				return await insert(
					Event.Identified(
						fields: fields,
						show: show,
						location: location,
						venue: venueID.asyncMap { venueID in
							let venueFields = await fetch(VenueBaseFields.self, with: venueID).value!
							let addressID = venueFields.address.id

							return .init(
								fields: venueFields,
								address: .init(
									fields: await fetch(AddressBaseFields.self, with: addressID).value!,
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
