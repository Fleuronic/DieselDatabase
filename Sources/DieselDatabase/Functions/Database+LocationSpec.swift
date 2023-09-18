// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Location
import struct DieselService.LocationBaseFields
import protocol DieselService.LocationSpec
import protocol Catenoid.Database

extension Database: LocationSpec {
	public func storeLocations(from list: [LocationBaseFields]) async -> Self.Result<[Location.ID]> {
		await delete(Location.Identified.self).asyncFlatMap { _ in
			await list.asyncFlatMap { fields in
				await insert(Location.Identified(fields: fields))
			}
		}
	}
}
