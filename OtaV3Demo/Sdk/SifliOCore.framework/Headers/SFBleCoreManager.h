//
//  SFBleCoreManager.h
//  SifliOCore
//
//  Created by Sean on 2023/10/30.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFBleCoreManagerState.h>
#import <SifliOCore/SFCBPeripheral.h>
#import <SifliOCore/SFCoreError.h>
#import <SifliOCore/SFDeviceID.h>

NS_ASSUME_NONNULL_BEGIN
@class SFBleCoreManager;
@protocol SFBleCoreManagerDelegate <NSObject>
//蓝牙状态改变
- (void)bleCoreManager:(SFBleCoreManager *)manager didUpdateState:(SFBleCoreManagerState) state;
//发现了外设
- (void)bleCoreManager:(SFBleCoreManager *)manager didDiscover:(SFCBPeripheral *) peripheral;
//连接失败
- (void)bleCoreManager:(SFBleCoreManager *)manager failedToConnectPeripheral:(SFCBPeripheral *) peripheral error:(SFCoreError *)error;
- (void)bleCoreManager:(SFBleCoreManager *)manager disconnectToPeripheral:(SFCBPeripheral *) peripheral error:(SFCoreError *)error;
//连接失败
- (void)bleCoreManager:(SFBleCoreManager *)manager successToConnect:(SFCBPeripheral *) peripheral handeShaked:(BOOL) handeShaked;
//连接成功
- (void)bleCoreManager:(SFBleCoreManager *)manager characteristic:(CBCharacteristic *) characteristic didUpdateValue:(NSData *) value;
//收到数据
- (void)bleCoreManager:(SFBleCoreManager *)manager didWriteValue:(CBCharacteristic *) characteristic error:(NSError *)error;

@end

@interface SFBleCoreManager : NSObject
@property (nonatomic,weak) id<SFBleCoreManagerDelegate> delegate;
///当前连接的外设
@property (nonatomic,strong,readonly) SFCBPeripheral *currentPeripheral;
@property (nonatomic,assign,readonly) BOOL isShakedHands;
@property (nonatomic,assign,readonly) SFBleCoreManagerState state;

+ (SFBleCoreManager *)shared;

/// 获取已经连接的设备
- (NSArray<SFCBPeripheral *> *)retrievePairedPeripherals;

/// 扫描设备
/// - Parameter withServicesFilter: 是否过滤服务id
- (void)startScan:(BOOL)withServicesFilter;

/// 停止扫描
- (void)stopScan;

/// 取消连接
- (void)cancelConnection;

/// 连接
/// - Parameters:
///   - peripheral: 外设
///   - shakeHands: 是否要握手
///   - notify: 是否要注册通知
- (void)connectToPeripheral:(SFCBPeripheral *)peripheral
             withShakeHands:(BOOL)shakeHands
                 withNotify:(BOOL)notify;

/// 写入数据
/// - Parameter value: 数据
- (void)writeValueForWriteCharateristic:(NSData *)value;

@end

NS_ASSUME_NONNULL_END
