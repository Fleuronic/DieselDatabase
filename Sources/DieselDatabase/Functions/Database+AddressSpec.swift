// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Address
import struct DieselService.AddressBaseFields
import struct DieselService.LocationBaseFields
import protocol DieselService.AddressSpec
import protocol Catenoid.Database

extension Database: AddressSpec {
	public func storeAddresses(from list: [AddressBaseFields]) async -> Self.Result<[Address.ID]> {
		await delete(Address.Identified.self).asyncFlatMap { _ in
			await list.asyncFlatMap { fields in
				await insert(
					Address.Identified(
						fields: fields,
						location: .init(
							fields: await fetch(LocationBaseFields.self, with: fields.locationID).value!
						)
					)
				)
			}
		}
	}
}
