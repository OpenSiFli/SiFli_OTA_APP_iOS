//
//  CBPeripheral+Extension.swift
//  SFIntegration
//
//  Created by Sean on 2023/8/3.
//

import Foundation
import CoreBluetooth

 extension CBPeripheral{
    private struct AssociationKeys {
        static var RSSIKey:String = "RSSIKey"
    }
    func getRssi() -> NSNumber?{
        return objc_getAssociatedObject(self, &AssociationKeys.RSSIKey) as? NSNumber
    }
    
    func setRssi(rssi:NSNumber?){
        objc_setAssociatedObject(self, &AssociationKeys.RSSIKey, rssi, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
