//
//  SFDataUtil.h
//  SifliOCore
//
//  Created by Sean on 2023/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFDataUtil : NSObject

/// 将数据输出为16进制字符串 100字节上限，超过截断.
/// - Parameter data: 数据
+ (NSString *)hexStringFromData100:(NSData *)data;

/// 将16进制字符串转为NSData
/// - Parameter hexStr: 16进制字符串
+ (NSData *)dataFromHexString:(NSString *)hexStr;
+ (NSString *)summary:(NSData *)data;

/// 切割数据
/// - Parameters:
///   - data: 源数据
///   - upperlimit: 最大长度
+ (NSArray<NSData *> *)splitData:(NSData *)data upperlimit:(NSInteger)upperlimit;

+ (NSData *)convertUint16ToUint8Data:(uint16_t)value;

+ (uint32_t)covertDataToUnit32:(NSData *)data;

+ (uint16_t)covertDataToUnit16:(NSData *)data;

+ (NSData *)convertUInt8ToData:(uint8_t)value;
+ (NSData *)convertUInt16ToData:(uint16_t)value;
+ (NSData *)convertUInt32ToData:(uint32_t)value;

+ (uint8_t)getByteFromData:(NSData *)data index:(NSInteger)index;
+ (uint16_t)getUint16FromData:(NSData *)data index:(NSInteger)index;
+ (uint32_t)getUint32FromData:(NSData *)data index:(NSInteger)index;


/// CRC 从swit迁移而来
/// - Parameters:
///   - data:
///   - offset:
///   - length: 
+ (uint32_t) CRC32_MPEG2:(NSData *)data offset:(NSInteger)offset length:(NSInteger)length;

/// 基于一个已有的Crc值，对数据片段进行crc计算，并返回crc值
/// - Parameters:
///   - data: 数据片段
///   - length: 数据长度
///   - lastCrc: 已有的crc值
+ (uint32_t) CRC32_MPEG2WithData:(NSData *)data  length:(NSInteger)length lastCrc:(uint32_t)lastCrc;

/// 使用一个字节对目标数据做crc补齐
/// - Parameters:
///   - srcData:数据
///   - padding: 0x00,0x20
+ (NSData *) appendCRCWithData:(NSData *)srcData paddingByte:(uint8_t)padding;


/// 计算切片数量
/// - Parameters:
///   - totalBytes: 总长度
///   - sliceLength: 切片长度
+ (uint64_t)computeSliceCount:(uint64_t)totalBytes sliceLength:(uint16_t)sliceLength;

+ (NSData *)mergeData1:(NSData *)data1 data2:(NSData *)data2;

/// 从一个数据的某个开始位置拷贝指定长度的数据返回
/// - Parameters:
///   - data: 数据源
///   - start: 开始位置
///   - length: 长度
+ (NSData *)copyFrom:(NSData *)data start:(NSInteger)start length:(NSInteger)length;

+ (uint32_t)calculateFileBlock:(uint16_t)blockLength fileLength:(uint64_t)fileLength;

+ (NSData *)makeDataWithLength:(NSInteger)len byte:(uint8_t)paddingByte;
@end

NS_ASSUME_NONNULL_END
