// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PayPalRetailSDK",
  products: [
    .library(
      name: "PayPalRetailSDK",
      targets: [
        "PayPalRetailSDK",
        "PPRetailInstrumentInterface",
      ]
    )
  ],
  dependencies: [
    /// This doesn't have any SPM dependencies, though it does require that SimpleKeychain
    /// and TrustKit are installed through other means. Right now, that means Carthage.
    /// For whatever reason, PayPal won't link to the SimpleKeychain and TrustKit frameworks
    /// if they're imported through the SPM dependencies manifest, and I don't understand
    /// why.
  ],
  targets: [
    // https://github.com/paypal/paypal-here-sdk-ios-distribution/releases/tag/sdk_v2.4.0021363000
    .binaryTarget(
      name: "PayPalRetailSDK",
      url:
        "https://github.com/schrismartin-eb/paypal-here-sdk-ios-distribution/raw/release/2.4.0021363000/RSDK/Release/PayPalRetailSDK.xcframework.zip",
      checksum: "26f88acb0f14b067af7d2a8541d6837ff6b7731b65a90a343407951ae15d8626"
    ),
    .binaryTarget(
      name: "PPRetailInstrumentInterface",
      url:
        "https://github.com/schrismartin-eb/paypal-here-sdk-ios-distribution/raw/release/2.4.0021363000/RSDK/Release/PPRetailInstrumentInterface.xcframework.zip",
      checksum: "55c8717ffc43c8fc284039d72398a496d803267ca8d4ed2bb2f675e06c6dc2e8"
    ),
  ]
)
