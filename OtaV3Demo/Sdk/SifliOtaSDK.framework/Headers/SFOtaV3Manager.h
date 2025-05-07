//
//  SFOtaV3Manager.h
//  SifliOtaSdk
//
//  Created by Sean on 2024/7/26.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SifliOCore.h>
#import <SifliOtaSDK/SFOtaV3FileInfo.h>
#import <SifliOtaSDK/SFOtaV3ResourceFileInfo.h>
#import <SifliOtaSDK/SFOtaV3BinFileInfo.h>

#import <SifliOtaSDK/SFOtaV3Error.h>
NS_ASSUME_NONNULL_BEGIN

@class SFOtaV3Manager;
@protocol SFOtaV3ManagerDelegate <NSObject>

- (void)otaV3Manager:(SFOtaV3Manager *)manager updateBleState:(SFBleCoreManagerState)state;
- (void)otaV3Manager:(SFOtaV3Manager *)manager
               progress:(NSUInteger)completedBytes
              total:(NSUInteger)totalBytes;

- (void)otaV3Manager:(SFOtaV3Manager *)manager success:(BOOL)success errror:(nullable SFOtaV3Error *)error;
- (void)otaV3Manager:(SFOtaV3Manager *)manager updateManagerState:(SFBleShellStatus)state;

@end

@interface SFOtaV3Manager : NSObject
@property (nonatomic,weak) id<SFOtaV3ManagerDelegate> delegate;
+ (SFOtaV3Manager *)shared;
- (BOOL)isBusy;

/// 资源ota
/// - Parameters:
///   - identifier: 蓝牙设备地址
///   - otaV3Type: 0-表盘，1-多语言，2-背景图，3-自定义，4-音乐,5-JS,8-4G模块，9-GUIBuilder 表盘,12-GUIBuilder App,13-GUIBuilder 扩展资源。其它类型查阅文档
///   - resourceFile: 资源文件描述
///   - tryResume: 是否尝试续传
- (void)startOtaResWithIdentifier:(NSString *)identifier
                          otaV3Type:(SFOtaV3Type)otaV3Type
                       resourceFile:(SFOtaV3ResourceFileInfo *)resourceFile
                          tryResume:(BOOL)tryResume;

/// 固件ota
/// - Parameters:
///   - identifier: 蓝牙设备地址
///   - resourceFile: 资源文件描述
///   - imageFiles: 固件ota的bin文件，包括ctrl packet
///   - tryResume: 是否尝试续传
- (void)startOtaFirmwareWithIdentifier:(NSString *)identifier
                          resourceFile:(nullable SFOtaV3ResourceFileInfo *)resourceFile
                            imageFIles:(nullable NSArray<SFOtaV3BinFileInfo *> *)imageFiles
                             tryResume:(BOOL)tryResume;
///用户取消
///开始传输后，用户可以取消任务。但TotalEnd命令发出后，无法取消。
///@return 是否执行取消。如果时机偏晚，则无法取消。
- (BOOL)userCancel;

///强制断开连接
- (void)stop;
@end

NS_ASSUME_NONNULL_END
