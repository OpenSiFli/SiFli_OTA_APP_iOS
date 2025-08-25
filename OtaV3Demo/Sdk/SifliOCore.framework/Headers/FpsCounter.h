//
//  FpsCounter.h
//  SifliOCore
//
//  Created by Sean on 2025/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FpsCounter : NSObject

@property (nonatomic, readonly) float fps;

- (void)recordFrame;
- (float)getFps;
- (NSInteger)frameCount;

@end

NS_ASSUME_NONNULL_END
