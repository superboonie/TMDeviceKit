# TMDeviceKit

TMDeviceKit provides a few classes for querying device spec and display spec through UIDeviceExtraInfo, DeviceSpec, DisplaySpec classes.

This library simplifies the task of getting information not only on the running device, but any device in the iOS family.

TMDeviceKit supports all modern iOS devices (including Apple Watch and Apple TV) that runs iOS 7+ and soon Mac OS.

## Requirements
Swift 2.0+

## How it works

// Query current device directly using UIDevice
let extraInfo = UIDevice.currentDevice().extraInfo

//or supply a device to UIDeviceExtraInfo
let extraInfo = UIDeviceExtraInfo(UIDevice.currentDevice())

// Query memory (GB)
extraInfo.physicalMemory

// OS version
extraInfo.osVersion  // returns NSOperatingSystem instance

struct NSOperatingSystemVersion {
    var majorVersion: Int
    var minorVersion: Int
    var patchVersion: Int
    init()
    init(majorVersion majorVersion: Int, minorVersion minorVersion: Int, patchVersion patchVersion: Int)
}

// Check if OS is at least 8.1.1
extraInfo.isOperatingSystemAtLeastVersion("8.1.1")
or
extraInfo.isOperatingSystemAtLeastVersion(NSOperatingSystem(majorVersion: 8, minorVersion: 1, patchVersion: 1))

// Query CPU info
let cpuInfo = extraInfo.cpuInfo

// CPU Frequency (Hz)
cpuInfo.cpuFrequency

// Number of Cores
cpuInfo.numberOfCores

// L2 Cache Size (Bytes)
cpuInfo.l2CacheSize

// Device spec
extraInfo.spec

// Device type
extraInfo.spec.type // returns DeviceType, e.g. DeviceType.iPhone5
extraInfo.spec.subtype // returns DeviceSubtype, e.g. option set: [DeviceSubType.GSM, DeviceSubType.WiFi]
extraInfo.spec.display // returns DisplaySpec

// Display Spec
extraInfo.spec.display.pointResolution // e.g. 320x568 for DeviceType.iPhone6
extraInfo.spec.display.physicalPixelResolution // e.g. 750x1334 for DeviceType.iPhone6
extraInfo.spec.display.pixelsPerInch // e.g. 326
extraInfo.spec.display.renderedPixelResolution // e.g. 640x1136 for DeviceType.iPhone6

// or alternatively, query the display spec of any device type like this:
let display = DisplaySpec(deviceType: .iPhone6)  // get the point resolution of iPhone 6

