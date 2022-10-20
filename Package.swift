// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "LunhCheck",
	platforms: [
		.iOS(.v11)
	],
	products: [
		.library(
			name: "LunhCheck",
			targets: ["LunhCheck"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "LunhCheck",
			dependencies: []),
		.testTarget(
			name: "LunhCheckTests",
			dependencies: ["LunhCheck"]),
	]
)
