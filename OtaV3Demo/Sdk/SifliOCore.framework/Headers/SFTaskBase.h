//
//  SFTaskBase.h
//  SFWatchfaceSDK
//
//  Created by Sean on 2023/11/3.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFCoreError.h>


NS_ASSUME_NONNULL_BEGIN
@class SFTaskBase;
@protocol SFTaskDelegate <NSObject>

- (void)sfTask:(SFTaskBase *)task
            isSuccess:(BOOL)success
                error:(nullable SFCoreError *)error;
- (void)sfTask:(SFTaskBase *)task
             progress:(NSUInteger)currentBytes
                total:(NSUInteger)totalBytes;
@end

@interface SFTaskBase : NSObject
@property (nonatomic,weak) id<SFTaskDelegate> delegate;

- (void)startTimer;
- (void)stopTimer;
- (void)setCountDown:(NSInteger)countDown;
- (NSUInteger)getContinueSendNoResponsePacketCount:(NSUInteger)newIndex rspFreq:(NSUInteger)rspFreq;

@end

NS_ASSUME_NONNULL_END
