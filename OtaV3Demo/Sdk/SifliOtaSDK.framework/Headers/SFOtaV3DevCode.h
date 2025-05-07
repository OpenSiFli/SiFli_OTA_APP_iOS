//
//  SFOtaV3DeviceCode.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/8/5.
//  设备错误码

#ifndef SFOtaV3DevCode_h
#define SFOtaV3DevCode_h
typedef NS_ENUM(NSUInteger, SFOtaV3DevCode) {
    /**成功*/
    SFOtaV3DevCodeSuccess = 0,
    /**文件序号出错*/
    SFOtaV3DevCodePacketIndexError = 13,
    SFOtaV3DevCodePacketVerifyError = 15,
    ///需要重传当前的bin
    SFOtaV3DevCodeReSendBinError = 19
};

#endif /* SFOtaV3DeviceCode_h */
