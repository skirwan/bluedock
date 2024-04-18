//
//  IOBluetoothDevice+get.swift
//  BlueDockDaemon
//
//  Created by Sean Kerwin on 4/18/24.
//

import IOBluetooth

extension IOBluetoothDevice {
    static func get(addressString: String) -> IOBluetoothDevice? {
        if let k = IOBluetoothDevice(addressString: addressString) {
            return k
        }
        
        return IOBluetoothDevice.recentDevices(0).first { k in
            guard let k = k as? IOBluetoothDevice else { return false }
            return k.addressString == addressString
        } as? IOBluetoothDevice
    }
    
    static func get(addressStrings: [String]) -> [IOBluetoothDevice] {
        return addressStrings.compactMap(Self.get(addressString:))
    }
}
