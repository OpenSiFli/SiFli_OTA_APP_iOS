//
//  SFOtaV3FileInfo.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFOtaV3Type) {
    SFOtaV3TypeDynamicModule = 0,//表盘
    SFOtaV3TypeMutilLanguage = 1,//多语言
    SFOtaV3TypeBgPicture = 2,//背景图
    SFOtaV3TypeCustomFile = 3,//自定义
    SFOtaV3TypeMusic = 4,//背景音乐
    SFOtaV3TypeQjs = 5,//JavaScript
    SFOtaV3TypePhotoView = 7,//拍照预览
    SFOtaV3TypeAicModule = 8,//4g模块
    SFOtaV3TypeSilfiWatchface = 9,//SifliGuiBuiler 表盘
    SFOtaV3TypeFirmware = 10,//固件
    SFOtaV3TypeFirmwareManager = 11,//固件 ota manager
    SFOtaV3TypeSifliApp = 12,//SifliGuiBuilder app
    SFOtaV3TypeSifliAppRes = 13,//SifliGuiBuilder app 拓展资源
    SFOtaV3TypeSifliAppWidget = 14//SifliGuiBuilder app 拓展组件
};

typedef NS_ENUM(NSUInteger, SFOtaV3DfuFileType) {
    SFOtaV3DfuFileTypeZipResource = 0,//zip资源文件
    SFOtaV3DfuFileTypeZipResourceNoFilePath = 1,//zip资源没有路径
    SFOtaV3DfuFileTypeCtrlFile = 2,//固件ota 控制文件
    SFOtaV3DfuFileTypeBinFile = 3,//固件ota image bin文件
    SFOtaV3DfuFileTypeTransBinFile = 4,//直接传输的bin文件
};
@interface SFOtaV3FileInfo : NSObject
@property (nonatomic,copy,readonly)NSString *filePath;
@property (nonatomic,assign,readonly)SFOtaV3DfuFileType fileType;
- (instancetype)initWidthFileType:(SFOtaV3DfuFileType)fileType filePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
