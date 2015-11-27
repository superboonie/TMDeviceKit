# TMDeviceKit

TMDeviceKit provides a library of classes for querying device spec and display spec through UIDeviceExtraInfo, DeviceSpec, DisplaySpec classes and more.

This library simplifies the task of getting information for not only the running device, but any device in the iOS family for your general purpose use.

TMDeviceKit supports all modern iOS devices (including Apple Watch and Apple TV) that runs iOS 7+ and soon Mac OS.

## Requirements
Swift 2.0+

## How it works

### Query current device
```
// Query current device directly using UIDevice
let extraInfo = UIDevice.currentDevice().extraInfo

//or supply a device to UIDeviceExtraInfo
let extraInfo = UIDeviceExtraInfo(UIDevice.currentDevice())
```

### Physical memory

```
// Physical memory in GB
extraInfo.physicalMemory

```
### OS Version

```
extraInfo.osVersion  // returns NSOperatingSystem instance

struct NSOperatingSystemVersion {
    var majorVersion: Int
    var minorVersion: Int
    var patchVersion: Int
    init()
    init(majorVersion majorVersion: Int, minorVersion minorVersion: Int, patchVersion patchVersion: Int)
}

// Check if OS is at least 8.1.1

// ...using version string
extraInfo.isOperatingSystemAtLeastVersion("8.1.1")

// ...using NSOperatingSystem instance
extraInfo.isOperatingSystemAtLeastVersion(NSOperatingSystem(majorVersion: 8, minorVersion: 1, patchVersion: 1))

```
### Query CPU info
```
let cpuInfo = extraInfo.cpuInfo

// CPU Frequency (Hz)
cpuInfo.cpuFrequency

// Number of Cores
cpuInfo.numberOfCores

// L2 Cache Size (Bytes)
cpuInfo.l2CacheSize

```
### Device Spec

Device spec contains the family (iPhone, iPad, AppleTV, etc.), type (iPhone 5/5c/5s/6/6s, etc.), subtype (WiFi, GSM, CDMA, etc.) of the device. It also contains the display spec of the device.

```
// Device spec
extraInfo.spec

// Device type
extraInfo.spec.type    // returns DeviceType, e.g. DeviceType.iPhone5
extraInfo.spec.subtype // returns DeviceSubtype, e.g. option set: [DeviceSubType.GSM, DeviceSubType.WiFi]
extraInfo.spec.display // returns DisplaySpec

```

### Display Spec

Display spec of a device contains information such as point resolution (pixel-independent), rendered pixel resolution, physical pixel resolution, pixels per inch, etc.

```

// e.g. 320x568 for DeviceType.iPhone6
extraInfo.spec.display.pointResolution

// e.g. 640x1136 for DeviceType.iPhone6
extraInfo.spec.display.renderedPixelResolution

// e.g. 750x1334 for DeviceType.iPhone6
extraInfo.spec.display.physicalPixelResolution

// e.g. 326 for DeviceType.iPhone6
extraInfo.spec.display.pixelsPerInch 

// or alternatively, query the display spec of any device type like this:
let displaySpec = DisplaySpec(deviceType: .iPhone6)  // get the point resolution of iPhone 6
displaySpec.physicalPixelResolution                  // e.g. 750x1334 for DeviceType.iPhone6


```
