// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AOC2024",
  platforms: [.macOS(.v14)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3")
  ],
  targets: [
    .executableTarget(
      name: "runner",
      dependencies: [
        "Lib",
        "Days",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]),
    .target(
      name: "Lib"),
    .target(
      name: "Days",
      dependencies: [
        "Lib"
      ]),
  ]
)
