# crypto-benchmarks
Sandbox project to measure benchmarks between Themis and new Apple's CryptoKit


# Environment

### macOS
macOS 10.14.4, MBP late 2013, 2.8 GHz Intel Core i7

xcode 11 (Version 11.0 beta (11M336w))

```
pod --version
1.7.0
```

### iPadOS

iPad Pro 10", iOS13 beta


# To run

1. Open project folder, check Podfile. In Podfile uncommeet either Themis for OpenSSL or Themis for BoringSSL

2. Install dependencies
```
pod install
```

3. Run project on iOS simulator or on device.

4. Get benchmarks, copy-paste them into Numbers spreadsheets.

5. Enjoy

# What's next

This is work-in-progress project, I have a plan to continue research, then to publish results. But it depends on moon phase.
