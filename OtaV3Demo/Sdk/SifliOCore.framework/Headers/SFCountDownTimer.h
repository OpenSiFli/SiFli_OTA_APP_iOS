//
//  SFCountDownTimer.h
//  SifliOCore
//
//  Created by Sean on 2023/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SFCountDownTimerDelegate <NSObject>

- (void)countDownTimerOnTimeOut;

@end

@interface SFCountDownTimer : NSObject
- (instancetype)initWithName:(NSString *)name;

@property (nonatomic,weak) id<SFCountDownTimerDelegate> delegate;

- (void)startTimer:(NSInteger)countDown;

- (void)setCountDown:(NSInteger)countDown;

- (void)stopTimer;
@end

NS_ASSUME_NONNULL_END
