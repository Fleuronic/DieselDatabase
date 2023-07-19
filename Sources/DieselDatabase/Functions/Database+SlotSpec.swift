// Copyright © Fleuronic LLC. All rights reserved.

import struct Diesel.Event
import struct DieselService.SlotListFields
import protocol DieselService.SlotSpec
import protocol Catenoid.Database

extension Database: SlotSpec {
	public func listSlots(comprisingEventWith id: Event.ID) -> AsyncStream<Self.Result<[SlotListFields]>> {
		.init {
			await fetch(SlotListFields.self)
		}
	}
}
