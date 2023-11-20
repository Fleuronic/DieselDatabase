// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Show
import struct DieselService.ShowBaseFields
import protocol DieselService.ShowSpec
import protocol Catenoid.Database

extension Database: ShowSpec {
	public func storeShows(from list: [ShowBaseFields]) async -> Self.Result<[Show.ID]> {
		await delete(Show.Identified.self).asyncFlatMap { _ in
			await list.asyncFlatMap { fields in
				await insert(Show.Identified(fields: fields))
			}
		}
	}
}
