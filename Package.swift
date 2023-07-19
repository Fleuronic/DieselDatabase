// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "DieselDatabase",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "DieselDatabase",
			targets: ["DieselDatabase"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/Fleuronic/DieselService", branch: "main"),
		.package(url: "https://github.com/Fleuronic/Catenoid", branch: "main")
	],
	targets: [
		.target(
			name: "DieselDatabase",
			dependencies: [
				"DieselService",
				"Catenoid"
			]
		)
	]
)
