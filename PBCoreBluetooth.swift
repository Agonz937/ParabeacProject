//
//  PBCoreBluetooth.swift
//  PBCoreBluetooth
//
//  Created by Adrian Gonzalez on 11/4/18.
//  Copyright © 2018 Adrian Gonzalez. All rights reserved.
//

import CoreBluetooth
import UIKit

protocol PBCoreBluetoothDelegate {
    func updatedNearbyParabeac(peripherals : [CBPeripheral])
    func discoverPBServices(PBservices: [CBService], PBperipherial: CBPeripheral)
    func discoverPBCharacteristcs(PBCharacteristics: [CBCharacteristic])
}


class PBCoreBluetooth: NSObject{
    //Parabeac's UUID
    let paraBeacServicesUUID = CBUUID(string: "6E408888-B5A3-F393-E0A9-E50E24DCCA9E")
    let paraBeacCharacteristicCBUUID = CBUUID(string: "6E409999-B5A3-F393-E0A9-E50E24DCCA9E")
    
    // Used to store parabeac Peripherials
    private var parabeacPeripheralsNearby = [CBPeripheral]()
    // Used to store parabeacs Characteristics
    private var parabeacCharacteristics = [CBCharacteristic]()

    // Core Bluetooth fields purposes
    var centralManager: CBCentralManager!
    
    // Parabeacs fields
    var delegate: PBCoreBluetoothDelegate!
    var connect: CBPeripheral!
    var paraBeacServices =  [CBService]()
    var paraBeacCharacteristic = [CBCharacteristic]()
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    

}


extension PBCoreBluetooth: CBCentralManagerDelegate {
    
    // You implement this required method to ensure that Bluetooth low energy is supported and available to use on the central device
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [paraBeacServicesUUID])
        case .resetting:
            print("central.state is .resetting")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .unknown:
            print("central.state is .unknown")
        case .unsupported:
            print("central.state is .unsupported")
        }
    }
    
    
    // Invoked when the central manager discovers a peripheral while scanning.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Appending all of Parabeac's peripherals
        self.parabeacPeripheralsNearby.append(peripheral)
        self.delegate.updatedNearbyParabeac(peripherals: parabeacPeripheralsNearby)
        
        // Making the connection
        connect.delegate = self
        centralManager.connect(connect)
    }
    
    
    // This method is invoked when a call to connect(_:options:) is successful.
    // You typically implement this method to set the peripheral’s delegate and to discover its services.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        connect.discoverServices([paraBeacServicesUUID])
        
        
    }
}




extension PBCoreBluetooth: CBPeripheralDelegate{
    
    // This method is invoked when your app calls the discoverServices(_:) method.
    // If the services of the peripheral are successfully discovered, you can access them through the peripheral’s services property
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services{
            paraBeacServices.append(service)
        }
        self.delegate.discoverPBServices(PBservices: paraBeacServices, PBperipherial: peripheral)

    }
    
    // This method is invoked when your app calls the discoverCharacteristics(_:for:) method.
    // If the characteristics of the specified service are successfully discovered, you can access them through the service's characteristics property
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {return}
        
        for characteristc in characteristics{
            paraBeacCharacteristic.append(characteristc)
        }
        
        self.delegate.discoverPBCharacteristcs(PBCharacteristics: paraBeacCharacteristic)
    }
}

