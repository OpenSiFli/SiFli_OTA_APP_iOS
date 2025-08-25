//
//  SFPreviewVideoManager.h
//  SifliOtaSDK
//
//  Created by Sean on 2025/5/29.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SifliOCore/SifliOCore.h>
#import <SifliOtaSDK/SFPreviewImageConfigration.h>
#import <SifliOtaSDK/SFOtaV3Error.h>
NS_ASSUME_NONNULL_BEGIN

@class SFPreviewImageManager;
@protocol SFPreviewImageManagerDelegate <NSObject>

- (void)previewImageManager:(SFPreviewImageManager *)manager updateBleState:(SFBleCoreManagerState)state;
- (void)previewImageManager:(SFPreviewImageManager *)manager success:(BOOL)success errror:(nullable SFOtaV3Error *)error;
- (void)previewImageManager:(SFPreviewImageManager *)manager updateManagerState:(SFBleShellStatus)state;
///当前帧的发送进度，当进度达到一定时开始制作新帧
- (void)previewImageManager:(SFPreviewImageManager *)manager makeNextFrame:(float) process;
///初始化命令就绪，可以开始发送图片
- (void)previewImageManageReadyToSendImage;

@optional
/// 实时帧率
/// @param manager self
/// @param fps 帧率
- (void)previewImageManager:(SFPreviewImageManager *)manager fps:(float)fps;

/// 即将发送的图片数据
/// @param manager self
/// @param jpgData jpg数据
- (void)previewImageManager:(SFPreviewImageManager *)manager onImageMake:(NSData *)jpgData;
///已经发送图片数量，用于外部监测是否继续工作
- (void)previewImageManager:(SFPreviewImageManager *)manager imageCount:(NSInteger) imageCount;



@end

@interface SFPreviewImageManager : NSObject
@property (nonatomic,weak) id<SFPreviewImageManagerDelegate> delegate;
+ (SFPreviewImageManager *)shared;


/// 帧旅
@property (nonatomic,assign) float fps;

- (void)initSdk;
- (BOOL)isBusy;

/// 发起视频预览
/// 发起蓝牙连接，之后初始化传输，在状态未就绪前发送到priviewVideoSample的采样数据会被丢弃
/// - Parameter configration: 配置参数
- (void)startPreviewVideo:(SFPreviewImageConfigration *)configration targetIdentifier:(NSString *)identifier;

/// 向手表端发送视频采样
/// sdk根据SFPreviewVideoConfigration 的配置对采样进行处理，之后将jpeg数据通过蓝牙发送到手表端
/// - Parameter sample: 视频数据采样，通过AVCaptureVideoDataOutput 获得;
- (void)previewVideoSample:(UIImage *)sample;

/// 向固件发送音频数据
/// - Parameter audioData: 音频数据
- (void)previewAudio:(NSData *)audioData;

/// 结束预览视频,保持连接
- (void)endPreviewVideo;
/// 停止传输, 关闭连接
- (void)stop;
- (BOOL)canSendImage;
@end

NS_ASSUME_NONNULL_END
