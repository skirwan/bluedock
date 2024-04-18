//
//  main.swift
//  BlueDockDaemon
//
//  Created by Sean Kerwin on 4/17/24.
//

import IOBluetooth
import Foundation
import Darwin
import Cocoa

let daemon = Daemon(
    screenId: 458624307,
    addressStrings: [
        "90:9C:4A:05:BD:58",
        "90:9C:4A:A9:7F:D4"
    ]
)
withExtendedLifetime(daemon) {
    daemon.start()
    
    RunLoop.current.run()
}
