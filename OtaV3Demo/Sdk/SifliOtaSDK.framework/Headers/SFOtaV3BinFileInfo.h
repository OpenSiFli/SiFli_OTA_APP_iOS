//
//  SFOtaV3BinFileInfo.h
//  SifliOtaSDK
//
//  Created by Sean on 2024/7/27.
//

#import <SifliOtaSDK/SFOtaV3FileInfo.h>
#import <SifliOtaSDK/SFOtaV3ImageID.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFOtaV3BinFileInfo : SFOtaV3FileInfo
@property(nonatomic,assign) SFOtaV3ImageID imageId;
@property(nonatomic,copy,nullable)NSString *hexOffset;
- (instancetype)initWidthFileType:(SFOtaV3DfuFileType)fileType filePath:(NSString *)filePath imageId:(SFOtaV3ImageID)imageId;
@end

NS_ASSUME_NONNULL_END
