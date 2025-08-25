//
//  SFBleShell.h
//  SifliOCore
//
//  Created by Sean on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFCoreError.h>
#import <SifliOCore/SFBleCoreManagerState.h>
#import <SifliOCore/SFModuleBase.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kOCoreVersion = @"1.0.8";
typedef NS_ENUM(NSUInteger, SFBleShellStatus) {
    //空闲
    SFBleShellStatusNone = 0,
    //搜索设备
    SFBleShellStatusSearching = 1,
    //连接设备
    SFBleShellStatusConnecting = 2,
    //模块工作中
    SFBleShellStatusModuleWorking = 3
};

@class SFBleShell;
@protocol SFBleShellDelegate <NSObject>

- (void)bleShell:(SFBleShell *)shell updateBleState:(SFBleCoreManagerState)state;
- (void)bleShell:(SFBleShell *)shell updateShellState:(SFBleShellStatus)state;
- (void)bleShell:(SFBleShell *)shell progress:(NSUInteger)completeBytes total:(NSUInteger)totalBytes;
- (void)bleShell:(SFBleShell *)shell isSuccess:(BOOL)success error:(nullable SFCoreError *)error;

@end

@interface SFBleShell : NSObject<SFModuleDelegate>
@property (nonatomic,weak) id<SFBleShellDelegate> delegate;
@property (nonatomic,assign,readonly) BOOL isBusy;
@property (nonatomic,assign,readonly)SFBleShellStatus status;
@property (nonatomic,copy,nullable) NSString *targetDevIdentifier;
//用于SerialTransPacket,默认为0x00,在子类根据业务指定
@property (nonatomic,assign)uint8_t cateID;
@property (nonatomic,strong,nullable) SFModuleBase *currentModule;
///停止工作，断开连接
- (void)stop;
- (void)clearCaches;
//返回蓝牙是否可用
- (SFBleCoreManagerState)bleCoreState;
///设置blecore的委托到自身，避免多模块工作冲突。
- (void)updateBleCoreDelegateToSelf;

@end

NS_ASSUME_NONNULL_END
