// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Venue
import struct DieselService.VenueBaseFields
import struct DieselService.AddressBaseFields
import struct DieselService.LocationBaseFields
import protocol DieselService.VenueSpec
import protocol Catenoid.Database

extension Database: VenueSpec {
	public func storeVenues(from list: [VenueBaseFields]) async -> Self.Result<[Venue.ID]> {
		await delete(Venue.Identified.self).asyncFlatMap { _ in
			await list.asyncFlatMap { fields in
				let addressFields = await fetch(AddressBaseFields.self, with: fields.addressID).value!
				
				return await insert(
					Venue.Identified(
						fields: fields,
						address: .init(
							fields: addressFields,
							location: .init(
								fields: fetch(LocationBaseFields.self, with: addressFields.locationID).value!
							)
						)
					)
				)
			}
		}
	}
}
