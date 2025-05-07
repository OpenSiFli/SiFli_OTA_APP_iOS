//
//  SFStringUtil.h
//  SifliOCore
//
//  Created by Sean on 2024/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFStringUtil : NSObject
+ (BOOL)isNullOrEmpty:(NSString *)str;
+ (BOOL)isValidHexString:(NSString *)str;
+ (NSString *)paddingHexString:(NSString *)src toLen:(NSUInteger)len;
@end

NS_ASSUME_NONNULL_END
