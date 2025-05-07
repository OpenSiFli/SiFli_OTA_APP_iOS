//
//  SFOtaV3ImageIDUtil.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/8/6.
//

#import <Foundation/Foundation.h>
#import <SifliOtaSDK/SFOtaV3ImageID.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFOtaV3ImageIDUtil : NSObject

+ (BOOL)isValidImageId:(uint16_t)imageId;
@end

NS_ASSUME_NONNULL_END
