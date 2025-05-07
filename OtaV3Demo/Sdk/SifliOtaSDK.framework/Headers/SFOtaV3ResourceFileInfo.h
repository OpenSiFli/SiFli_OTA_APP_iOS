//
//  SFOtaV3ResourceFileInfo.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/7/27.
//

#import <SifliOtaSDK/SFOtaV3FileInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFOtaV3ResourceFileInfo : SFOtaV3FileInfo
@property(nonatomic,assign)BOOL withByteAlign;

- (instancetype)initWithFileType:(SFOtaV3DfuFileType)fileType
                filePath:(NSString *)filePath
           withByteAlign:(BOOL)withByteAlign;

- (BOOL)isFilePathNullOrEmpty;
@end

NS_ASSUME_NONNULL_END
