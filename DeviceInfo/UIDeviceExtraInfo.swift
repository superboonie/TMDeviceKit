//
//  DeviceInfo.swift
//  DeviceInfo
//
//  Created by BOON CHEW on 11/20/15.
//  Copyright © 2015 Tappollo Media. All rights reserved.
//

import UIKit

#if os(iOS)
    
    public enum DeviceFamily {
        case iPhone
        case iPad
        case iPodTouch
        case AppleTV
        case AppleWatch
        case Simulator
        case Unknown
    }
    
    public enum DeviceType {
        case Unknown
        case iPhone4, iPhone4s
        case iPhone5, iPhone5c, iPhone5s
        case iPhone6, iPhone6Plus
        case iPhone6s, iPhone6sPlus
        case iPad2
        case iPad3
        case iPad4
        case iPadMini1
        case iPadMini2
        case iPadMini3
        case iPadAir1
        case iPadAir2
        case iPadAir3
        case iPadPro
        case iPodTouch4
        case iPodTouch5
        case iPodTouch6
        case AppleTV
        case AppleWatch
        
        public var family: DeviceFamily {
            switch self {
                
            case .iPhone4, .iPhone4s,
            .iPhone5, .iPhone5c, .iPhone5s,
            .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus:
                return DeviceFamily.iPhone
                
            case iPad2, iPad3, iPad4,
            iPadMini1, iPadMini2, iPadMini3,
            iPadAir1, iPadAir2, iPadAir3,
            iPadPro:
                return DeviceFamily.iPad
                
            case iPodTouch4, iPodTouch5, iPodTouch6:
                return DeviceFamily.iPodTouch
                
            case .AppleTV:
                return DeviceFamily.AppleTV
                
            case .AppleWatch:
                return DeviceFamily.AppleWatch
                
            case Unknown:
                return DeviceFamily.Unknown
            }
        }
    }
    
    public enum DeviceSubtype {
        case WiFi
        case CDMA
        case GSM
        case China
    }
    
    public enum DeviceDisplay {
        case Unknown
        case iPad
        case iPadPro
        case iPhone35Inch
        case iPhone4Inch
        case iPhone47Inch
        case iPhone55Inch
    }
    
#elseif os(OSX)
    
    public enum DeviceFamily {
        case Unknown
        case iMac
        case MacMini
        case MacPro
        case MacBook
        case MacBookAir
        case MacBookPro
        case Xserve
    }
    
#endif

public struct DisplaySpec {
    
    public var pointResolution: CGSize
    public var renderedPixelResolution: CGSize
    public var physicalPixelResolution: CGSize
    public var pixelsPerInch: Float
    public var screenSize: Float
    
    init(deviceType: DeviceType) {
        self = DisplaySpec.displaySpecForDeviceType(deviceType)
    }
    
    init(pointResolution: CGSize, renderedPixelResolution: CGSize, physicalPixelResolution: CGSize, pixelsPerInch: Float, screenSize: Float) {
        self.pointResolution = pointResolution
        self.renderedPixelResolution = renderedPixelResolution
        self.physicalPixelResolution = physicalPixelResolution
        self.pixelsPerInch = pixelsPerInch
        self.screenSize = screenSize
    }
    
    static func displaySpecForDeviceType(type: DeviceType) -> DisplaySpec {
        switch type {
            
        case .iPhone4, .iPhone4s:
            return DisplaySpec(pointResolution: CGSize(width: 320, height: 480),
                renderedPixelResolution: CGSize(width: 640, height: 960),
                physicalPixelResolution: CGSize(width: 640, height: 960),
                pixelsPerInch: 326,
                screenSize: 3.5)
            
        case .iPhone5, .iPhone5c, .iPhone5s:
            return DisplaySpec(pointResolution: CGSize(width: 320, height: 568),
                renderedPixelResolution: CGSize(width: 640, height: 1136),
                physicalPixelResolution: CGSize(width: 640, height: 1136),
                pixelsPerInch: 326,
                screenSize: 4)
            
        case .iPhone6:
            return DisplaySpec(pointResolution: CGSize(width: 320, height: 568),
                renderedPixelResolution: CGSize(width: 640, height: 1136),
                physicalPixelResolution: CGSize(width: 750, height: 1334),
                pixelsPerInch: 326,
                screenSize: 4.7)
            
        case .iPhone6Plus:
            return DisplaySpec(pointResolution: CGSize(width: 375, height: 667),
                renderedPixelResolution: CGSize(width: 1242, height: 2208),
                physicalPixelResolution: CGSize(width: 1080, height: 1920),
                pixelsPerInch: 401,
                screenSize: 5.5)
            
        default:
            return DisplaySpec(pointResolution: CGSizeZero,
                renderedPixelResolution: CGSizeZero,
                physicalPixelResolution: CGSizeZero,
                pixelsPerInch: 0,
                screenSize: 0)
        }
    }
}

public struct DeviceSpec {
    var identifier: String
    var type: DeviceType
    var subtype: [DeviceSubtype] = []
    var display: DisplaySpec
    var family: DeviceFamily {
        return type.family
    }
}

extension NSOperatingSystemVersion: CustomStringConvertible {
    public var description: String {
        return "\(self.majorVersion).\(self.minorVersion).\(self.patchVersion)"
    }
}

public class UIDeviceExtraInfo {
    let device: UIDevice
    var systemInfo: utsname
    
    public var rawIdentifier: String
    
    private init(device: UIDevice) {
        self.device = device
        
        systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        let machineReflection = Mirror(reflecting: machine)
        
        let rawIdentifier = machineReflection.children.reduce("") {
            label, element in
            guard let value = element.value as? Int8 where value != 0 else {
                return label
            }
            
            return label + String(UnicodeScalar(UInt8(value)))
        }
        
        self.rawIdentifier = rawIdentifier
    }
    
    public func specForIdentifier(identifier: String) -> DeviceSpec {
        switch identifier {
            
        case "iPod5,1":         return DeviceSpec(identifier: self.rawIdentifier, type: .iPodTouch5, subtype: [.GSM], display: DisplaySpec(deviceType: .iPodTouch5))
        case "iPod7,1":         return DeviceSpec(identifier: self.rawIdentifier, type: .iPodTouch6, subtype: [], display: DisplaySpec(deviceType: .iPodTouch6))
            
        case "iPhone3,1":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone4, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
        case "iPhone3,2":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone4, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
        case "iPhone3,3":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone4, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
        case "iPhone4,1":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone4s, subtype: [.WiFi], display: DisplaySpec(deviceType: .iPhone5))
        case "iPhone5,1":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone5, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
        case "iPhone5,2":       return DeviceSpec(identifier: self.rawIdentifier, type: .iPhone5, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
            
        default:                return DeviceSpec(identifier: self.rawIdentifier, type: .Unknown, subtype: [], display: DisplaySpec(deviceType: .iPhone5))
        }
    }
    
    public var spec: DeviceSpec {
        return specForIdentifier(self.rawIdentifier)
    }
    
    public var osVersion: NSOperatingSystemVersion {
        if #available(iOS 8, *) {
            return NSProcessInfo().operatingSystemVersion
        } else {
            return versionFromVersionString(self.device.systemVersion)
        }
    }
    
    final func versionFromVersionString(version: String) -> NSOperatingSystemVersion {
        let versionComponents = version.componentsSeparatedByString(".")
        var version: NSOperatingSystemVersion = NSOperatingSystemVersion()
        
        assert(versionComponents.count >= 2, "Version must have at least two components")
        
        version.majorVersion = Int(versionComponents[0]) ?? 0
        version.minorVersion = Int(versionComponents[1]) ?? 0
        
        if versionComponents.count > 2 {
            version.patchVersion = Int(versionComponents[2]) ?? 0
        }
        
        return version
    }
}

extension UIDeviceExtraInfo {
    func isOperatingSystemAtLeastVersion(version: NSOperatingSystemVersion) -> Bool {
        return version.majorVersion >= osVersion.majorVersion &&
            version.minorVersion >= osVersion.minorVersion &&
            version.patchVersion >= osVersion.patchVersion
    }
    
    func isOperatingSystemAtLeastVersion(version: String) -> Bool {
        let osVersion = versionFromVersionString(version)
        
        if #available(iOS 8, *) {
            return NSProcessInfo().isOperatingSystemAtLeastVersion(osVersion)
        } else {
            return isOperatingSystemAtLeastVersion(osVersion)
        }
    }
}

extension UIDeviceExtraInfo {
    public var physicalMemory: Float {
        return Float(NSProcessInfo.processInfo().physicalMemory) / 1073741824.0
    }
}

extension UIDeviceExtraInfo {
    public struct CPUInfo {
        public var cpuFrequency: Float! {
            if let info = querySystemInfo("hw.cpufrequency") {
                return Float(info) ?? 0.0
            } else {
                return nil
            }
        }
        
        public var numberOfCores: UInt! {
            // Value should match sysctl -a | egrep -i 'hw.machine|hw.model|hw.ncpu'
            if let info = querySystemInfo("hw.ncpu") {
                return UInt(info) ?? 0
            } else {
                return nil
            }
        }
        
        public var l2CacheSize: Float! {
            if let info = querySystemInfo("hw.l2cachesize") {
                return Float(info) ?? 0
            } else {
                return nil
            }
        }
        
        func querySystemInfo(infoKey: String) -> Float? {
            var size : Int = 0
            sysctlbyname(infoKey, nil, &size, nil, 0)
            
            if size == 0 {
                return 0.0
            }
            
            var info = [CChar](count: size, repeatedValue: 0)
            sysctlbyname(infoKey, &info, &size, nil, 0)
            
            var infoValue:Float
            
            switch size {
                
            case 4:
                infoValue = Float(UnsafePointer<Int32>(info).memory)
            case 8:
                infoValue = Float(UnsafePointer<Int64>(info).memory)
            default:
                infoValue = 0.0
            }
            
            return infoValue
        }
    }
    
    public var cpuInfo: CPUInfo {
        return CPUInfo()
    }
}


public extension UIDevice {
    var extraInfo: UIDeviceExtraInfo {
        return UIDeviceExtraInfo(device: self)
    }
}

//UIDevice.currentDevice().extraInfo
// UIDeviceExtraInfo(UIDevice.currentDevice())

//DisplaySpec(deviceType: .iPhone6).pointResolution

