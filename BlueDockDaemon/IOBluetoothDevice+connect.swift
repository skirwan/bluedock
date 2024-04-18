//
//  IOBluetoothDevice+connect.swift
//  BlueDockDaemon
//
//  Created by Sean Kerwin on 4/18/24.
//

import IOBluetooth

fileprivate class PairingDelegate: NSObject, IOBluetoothDevicePairDelegate {
    private var owner: IOBluetoothDevicePair?
    private let continuation: CheckedContinuation<(), Never>
    
    init(
        owner: IOBluetoothDevicePair,
        continuation: CheckedContinuation<(), Never>
    ) {
        self.owner = owner
        self.continuation = continuation
    }
    
    func devicePairingFinished(
        _ sender: Any!,
        error: IOReturn
    ) {
        self.owner = nil
        print("Connected")
        continuation.resume()
    }
    
    func deviceSimplePairingComplete(
        _ sender: Any!,
        status: BluetoothHCIEventStatus
    ) {
        
        self.owner = nil
        print("Connected")
        continuation.resume()
    }
}

extension IOBluetoothDevice {
    func connect() async {
        guard !self.isConnected() else { return }
        
        return await withCheckedContinuation { continuation in
            guard let pairer = IOBluetoothDevicePair(device: self) else { return }
            let delegate = PairingDelegate(owner: pairer, continuation: continuation)
            pairer.delegate = delegate
            pairer.start()
        }
    }
}
