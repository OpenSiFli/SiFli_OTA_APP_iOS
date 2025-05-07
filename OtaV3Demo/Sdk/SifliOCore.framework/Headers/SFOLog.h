//
//  SFOLog.h
//  SifliOCore
//
//  Created by Sean on 2023/11/1.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SFOLogLevel) {
    SFOLogLevelInfo  = 0,
    SFOLogLevelError   = 1,
    SFOLogLevelWarn    = 2,
    SFOLogLevelDebug   = 4,
};
@class SFOLog;
//OBJC_EXTERN void SFOLog(SFOLogLevel level,NSString *tag, NSString *format, ...) NS_FORMAT_FUNCTION(3, 4);
#define SFOLOG_LOG_MACRO(_level,_tag, fmt, ...) [SFOLog level:_level tag:_tag log:fmt, ##__VA_ARGS__]
#define SFLogError(tag,fmt, ...)   SFOLOG_LOG_MACRO(SFOLogLevelError,tag, fmt, ##__VA_ARGS__)
#define SFLogWarn(tag,fmt, ...)    SFOLOG_LOG_MACRO(SFOLogLevelWarn,tag, fmt, ##__VA_ARGS__)
#define SFLogInfo(tag,fmt, ...)    SFOLOG_LOG_MACRO(SFOLogLevelInfo,tag, fmt, ##__VA_ARGS__)
#define SFLogDebug(tag,fmt, ...)   SFOLOG_LOG_MACRO(SFOLogLevelDebug,tag, fmt, ##__VA_ARGS__)
NS_ASSUME_NONNULL_BEGIN



@interface SFOLog : NSObject
+ (void)level:(SFOLogLevel) level tag:(NSString *) tag log:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);
@end

NS_ASSUME_NONNULL_END
