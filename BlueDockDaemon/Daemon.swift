//
//  Daemon.swift
//  BlueDockDaemon
//
//  Created by Sean Kerwin on 4/17/24.
//

import Foundation
import IOBluetooth
import Cocoa

final class Daemon: NSObject, IOBluetoothDevicePairDelegate{
    private let screenId: CGDirectDisplayID
    private let devices: [IOBluetoothDevice]
    private var observer: NSObjectProtocol? = nil
    
    init(
        screenId: CGDirectDisplayID,
        addressStrings: [String]
    ) {
        self.screenId = screenId
        self.devices = IOBluetoothDevice.get(addressStrings: addressStrings)
    }
    
    func start() {
        guard self.observer == nil else { return }
        
        self.observer = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: NSApp,
            queue: OperationQueue.main
        ) { [weak self] notification -> Void in
            self?.reflectState()
        }
        
        DispatchQueue.main.async {
            self.reflectState()
        }
    }
    
    func stop() {
        guard let observer = self.observer else { return }
        NotificationCenter.default.removeObserver(observer)
        self.observer = nil
    }
    
    private func reflectState() {
        let devices = self.devices
        let docked = docked()
        
        print("Updating state; we are \(docked ? "DOCKED" : "NOT DOCKED").")
        
        Task.detached {
            for device in devices {
                print("Updating state for device \(device.label)")
                
                if docked {
                    await device.connect()
                } else {
                    await device.disconnect()
                }
            }
        }
    }
    
    private func docked() -> Bool {
        return NSScreen.screens.contains { screen in
            guard let id = screen.deviceDescription[.init("NSScreenNumber")] as? CGDirectDisplayID else { return false }
            return id == screenId
        }
    }
    
    deinit {
        stop()
    }
}

extension IOBluetoothDevice {
    var label: String {
        if let name = self.name, !name.isEmpty {
            return name
        }
        
        return "\(self)"
    }
}
