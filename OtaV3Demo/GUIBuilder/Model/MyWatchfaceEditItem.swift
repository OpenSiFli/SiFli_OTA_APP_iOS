//
//  MyWatchfaceEditItem.swift
//  SFIntegration
//
//  Created by Sean on 2026/2/26.
//

import UIKit
import SifliGUIBuilderSDK

public class MyWatchfaceEditItem {
    public var hasSend = false
    public let editItem: SGImageEditItem

    public init(imageEditItem: SGImageEditItem) {
        self.editItem = imageEditItem
    }

    public func getPatchFileName() -> String {
        return String(format: "%@.bin", editItem.hexUID ?? "")
    }
}
