// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Metric",
	platforms: [
		.iOS(.v16)
	],
    products: [
        .library(
            name: "DieselDatabase",
            targets: ["DieselDatabase"]
		)
    ],
	dependencies: [],
    targets: [
        .target(
            name: "DieselDatabase",
            dependencies: []
		)
    ]
)
