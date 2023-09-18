// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Platform",
  platforms: [.iOS(.v16)],
  products: [
    .library(
      name: "Platform",
      targets: ["Platform"]),
  ],
  dependencies: [
    .package(path: "../../ThirdParty/CombineNetwork"),
  ],
  targets: [
    
    .target(
      name: "Platform",
      dependencies: [
        "CombineNetwork"
      ],
    resources: [
      .process("Resource/Mock/now_playing_1.json"),
      .process("Resource/Mock/now_playing_2.json"),
      .process("Resource/Mock/search_movie_1.json"),
      .process("Resource/Mock/search_person_1.json"),
      .process("Resource/Mock/search_keyword_1.json"),
    ]
    ),
    .testTarget(
      name: "PlatformTests",
      dependencies: ["Platform"]),
  ]
)
