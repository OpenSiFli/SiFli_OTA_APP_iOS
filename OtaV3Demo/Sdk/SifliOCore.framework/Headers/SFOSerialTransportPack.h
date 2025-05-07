//
//  SFSerialTransportPack.h
//  SifliOCore
//
//  Created by Sean on 2023/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFOSerialTransportPack : NSObject
@property (nonatomic,assign) uint8_t cateID;
@property (nonatomic,assign) uint8_t flag;

/// 同一组的包中，所有包的data部分的总长度（同一组的包中，只有第一个包才携带此字段）
@property (nonatomic,assign) uint16_t serialDataLength;
@property (nonatomic,strong) NSData *payloadData;


/// 构建SFSerialTransportPack
/// - Parameters:
///   - cateID: cateID 参见通信协议文档
///   - serialDataLength: 同一组的包中，所有包的data部分的总长度（同一组的包中，只有第一个包才携带此字段）
///   - payloadData: 携带数据
- (instancetype)initWithCateID:(uint8_t)cateID
                          flag:(uint8_t)flag
              serialDataLength:(uint16_t)serialDataLength
                   payloadData:(NSData *)payloadData;
- (instancetype)initWithCateID:(uint8_t)cateID
                          flag:(uint8_t)flag;

/// 生成发送数据
- (NSData *)marshal;


/// 从收到的数据解析为packet列表
/// - Parameters:
///   - mtu: mtu
///   - msgData: 收到数据
///   - cateID: cateID
+ (NSArray<SFOSerialTransportPack *> *)parsePacketsWithMtu:(NSInteger)mtu
                                                  msgData:(NSData *)msgData
                                                   cateID:(uint8_t)cateID;
@end

NS_ASSUME_NONNULL_END
