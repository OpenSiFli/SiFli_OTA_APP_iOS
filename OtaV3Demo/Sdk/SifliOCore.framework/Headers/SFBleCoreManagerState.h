//
//  SFBleCoreManagerState.h
//  SifliOCore
//
//  Created by Sean on 2023/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///蓝牙状态
typedef NS_ENUM(NSUInteger, SFBleCoreManagerState) {
    SFBleCoreManagerStateUnkown = 0,
    SFBleCoreManagerStateResetting = 1,
    SFBleCoreManagerStateUnsupported = 2,
    SFBleCoreManagerStateUnauthorized = 3,
    SFBleCoreManagerStatePoweredOff = 4,
    SFBleCoreManagerStatePoweredOn = 5
};
NS_ASSUME_NONNULL_END

