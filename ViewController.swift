//
//  ViewController.swift
//  PBCoreBluetooth
//
//  Created by Adrian Gonzalez on 11/4/18.
//  Copyright © 2018 Adrian Gonzalez. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, PBCoreBluetoothDelegate {
    func discoverPBServices(PBservices: [CBService], PBperipherial: CBPeripheral) {
        for service in PBservices{
            print(service)
            PBperipherial.discoverCharacteristics(nil, for: service)
        }
    }
    
    func discoverPBCharacteristcs(PBCharacteristics: [CBCharacteristic]) {
        for characteristics in PBCharacteristics{ print(characteristics) }
    }
    
    
    func updatedNearbyParabeac(peripherals: [CBPeripheral]) {
        print(peripherals)
        // This chooses which Parabeac periphial to connect to.
        cb.connect = peripherals[0]
    }
    
    
    let cb = PBCoreBluetooth()
    override func viewDidLoad() {
        super.viewDidLoad()
        //let cb = PBCoreBluetooth()
        cb.delegate = self
    }
}

