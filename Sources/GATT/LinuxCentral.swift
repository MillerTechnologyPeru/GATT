//
//  LinuxCentral.swift
//  GATT
//
//  Created by Alsey Coleman Miller on 1/22/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

#if os(Linux) || (Xcode && SWIFT_PACKAGE)
    
    import Foundation
    import Bluetooth
    import BluetoothLinux
    
    @available(OSX 10.12, *)
    public final class LinuxCentral: NativeCentral {
        
        public var log: ((String) -> ())?
        
        public init() {
            
            fatalError()
        }
        
        /// Scans for peripherals that are advertising services.
        public func scan(filterDuplicates: Bool,
                         shouldContinueScanning: () -> (Bool),
                         foundDevice: @escaping (ScanData) -> ()) {
            
            fatalError()
        }
        
        public func connect(to peripheral: Peripheral, timeout: Int = 5) throws {
            
            fatalError()
        }
        
        public func discoverServices(for peripheral: Peripheral) throws -> [CentralManager.Service] {
            
            fatalError()
        }
        
        public func discoverCharacteristics(for service: BluetoothUUID,
                                            peripheral: Peripheral) throws -> [CentralManager.Characteristic] {
            
            fatalError()
        }
        
        public func read(characteristic uuid: BluetoothUUID,
                  service: BluetoothUUID,
                  peripheral: Peripheral) throws -> Data {
            
            fatalError()
        }
        
        public func write(data: Data,
                   response: Bool,
                   characteristic uuid: BluetoothUUID,
                   service: BluetoothUUID,
                   peripheral: Peripheral) throws {
            
            fatalError()
        }
        
        public func notify(characteristic: BluetoothUUID,
                    service: BluetoothUUID,
                    peripheral: Peripheral,
                    notification: ((Data) -> ())?) throws {
            
            fatalError()
        }
    }

#endif

#if os(Linux)
    
    /// The platform specific peripheral.
    public typealias CentralManager = LinuxCentral
    
#endif
