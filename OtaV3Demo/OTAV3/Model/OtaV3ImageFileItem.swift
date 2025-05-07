//
//  OtaV3ImageFileItem.swift
//  SFIntegration
//
//  Created by Sean on 2024/8/26.
//

import UIKit
import SifliOtaSDK

class OtaV3ImageFileItem: NSObject {
    public var fileUrl:URL
    public var imageId:SFOtaV3ImageID?
    public var hexOffset:String?
    init(fileUrl: URL, imageId: SFOtaV3ImageID?, hexOffset: String? = nil) {
        self.fileUrl = fileUrl
        self.imageId = imageId
        self.hexOffset = hexOffset
    }
}
