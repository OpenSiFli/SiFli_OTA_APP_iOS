//
//  SFModuleBase.h
//  SFWatchfaceSDK
//
//  Created by Sean on 2023/11/2.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFCoreError.h>
#import <SifliOCore/SFBleCoreManager.h>
#import <SifliOCore/SFBleCoreManagerState.h>
#import <SifliOCore/SFOLog.h>
//#import "SFWatchfaceSDK/SFWatchfaceError.h"

NS_ASSUME_NONNULL_BEGIN
@class SFModuleBase;
@protocol SFModuleDelegate <NSObject>
- (void)sfModuleDisconnectRequest:(SFModuleBase *)sfModule;
- (void)sfModuleReconnectRequest:(SFModuleBase *)sfModule;
- (void)sfModule:(SFModuleBase *)sfModule sendData:(NSData *)data;
- (void)sfModule:(SFModuleBase *)sfModule fileProgress:(NSUInteger)completeBytes total:(NSUInteger)totalBytes;
- (void)sfModuleComplete:(SFModuleBase *)sfModule success:(BOOL)success error:(nullable SFCoreError *)error;
- (BOOL)sfModuleShakedHands;
@end

@interface SFModuleBase : NSObject
@property (nonatomic,copy,readonly)NSString *name;
@property (nonatomic,weak) id<SFModuleDelegate> delegate;
- (instancetype)initWithName:(NSString *)name;
- (void)bleEventHandler:(SFBleCoreManager *)bleCore onSearchTimeoutWithError:(SFCoreError *)error;
- (void)bleEventHandler:(SFBleCoreManager *)bleCore onFailToConnect:(SFCoreError *)error;
- (void)bleEventHandlerOnShakedHands;
- (void)bleEventHandler:(SFBleCoreManager *)bleCore onDisconnected:(SFCoreError *)error;
- (void)bleEventHandler:(SFBleCoreManager *)bleCore onUpdateState:(SFBleCoreManagerState)state;
- (void)bleEventHandler:(SFBleCoreManager *)bleCore onReceiveData:(NSData *)data;

/// 任务结束后，清除缓存，恢复状态
- (void)clear;

@end

NS_ASSUME_NONNULL_END
