//
//  IOBluetoothDevice+disconnect.swift
//  BlueDockDaemon
//
//  Created by Sean Kerwin on 4/18/24.
//

import IOBluetooth

extension IOBluetoothDevice {
    func disconnect() async {
        guard self.isConnected() else { return }
        
        let selector = NSSelectorFromString("remove")
        if responds(to: selector) {
            perform(selector)
            print("Disconnected")
        } else {
            print("Could not disconnect")
        }
    }
}
