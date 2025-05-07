//
//  SFSysTool.h
//  SifliOCore
//
//  Created by Sean on 2024/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSysTool : NSObject
+ (BOOL)isDeviceOlderThanIPhone8;
+ (BOOL)isDeviceOlderThanIPhoneX;
+ (float)noRspPacketInterval:(uint16_t)sliceLength;
@end

NS_ASSUME_NONNULL_END
