//
//  SFWatchfaceError.h
//  SFWatchfaceSDK
//
//  Created by Sean on 2023/11/3.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFCoreError.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SFOtaV3ErrorType) {

    //搜索设备超时
    SFOtaV3ErrorTypeSearchTimeout = 100,
    //请求超时
    SFOtaV3ErrorTypeRequestTimeout = 110,
    //设备错误码 errorType 为此值时，devErrorCode有值。
    SFOtaV3ErrorTypeErrorCodeFromDevice = 120,
    //蓝牙状态异常
    SFOtaV3ErrorTypeUnavailableBleStatus = 130,
    //无效参数
    SFOtaV3ErrorTypeInvalidParams = 140,
    //数据超出范围
    SFOtaV3ErrorTypeOutOfRange = 150,
    //解析响应数据失败
    SFOtaV3ErrorTypeFailToParsePacket = 160,
    //用户主动停止
    SFOtaV3ErrorTypeUserStop = 170,
    //手表用户主动停止
    SFOtaV3ErrorTypeRemoteAbort = 180,
    //解压失败
    SFOtaV3ErrorTypeFailToUnzip = 190,
    //解压失败
    SFOtaV3ErrorTypeNoFileInZip = 200,
    //读取文件失败
    SFOtaV3ErrorTypeFailToReadFile = 210,
    //调试期间才可能出现的错误，正式版不应当出现
    SFOtaV3ErrorTypeDebug = 220,
    //设备返回无效的最大切片长度
    SFOtaV3ErrorTypeInvalidMaxDataLen = 230,
    //设备返回无效的块长度
    SFOtaV3ErrorTypeInvalidBlockLength = 240,
    //设备返回无效的期望索引
    SFOtaV3ErrorTypeInvalidExpectIndex = 250,
    ///lose check 返回错误码2，通信错误次数超过3
    ///可能是切片太大
    SFOtaV3ErrorTypePushSliceTooLarge = 260,
    SFOtaV3ErrorTypeSliceError = 270,
    ///无响应写入期间收到响应
    SFOtaV3ErrorTypeRspWhenNoRspWriting = 280,
    ///文件包序号错误
    SFOtaV3ErrorTypeV3FileDataRspError = 290,
    ///Image列表中没有找到对应的ImageID V3_
    SFOtaV3ErrorTypeV3HcpuImageIdNotFound = 300,
    ///固件端返回的完成切片数量错误
    SFOtaV3ErrorTypeV3HcpuImageDeviceCompleteCountInvalid = 310,
    ///差分包资源的orderFile 不存在
    SFOtaV3ErrorTypeV3NandResOrderFileNotExist = 320,
    ///nand res order file 清单中的文件不存在
    SFOtaV3ErrorTypeV3NandResSubFileNotExist = 330,
    ///ctrl file 校验错误
    SFOtaV3ErrorTypeV3CtrlFileValidateError = 340
};

@interface SFOtaV3Error : SFCoreError

@property (nonatomic,assign)NSInteger devErrorCode;
- (instancetype)initWithSFCoreError:(SFCoreError *)coreError;
- (instancetype)initWithErrorType:(SFOtaV3ErrorType)errorType desc:(NSString *)desc;
- (instancetype)initWithDeviceCode:(uint16_t)code;
@end

NS_ASSUME_NONNULL_END
