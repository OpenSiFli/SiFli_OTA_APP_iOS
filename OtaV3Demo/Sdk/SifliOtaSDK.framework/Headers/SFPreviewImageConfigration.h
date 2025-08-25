//
//  SFWatchfacePreviewVideoConfigration.h
//  SFWatchfaceSDK
//
//  Created by Sean on 2023/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPreviewImageConfigration : NSObject
/// 视频预览时转为jpg的压缩质量 0~ 1
@property (nonatomic,assign) float JpegQuality;
/// 手表视频预览的分辨率
@property (nonatomic,assign) CGSize watchScreenSize;
@property (nonatomic,assign) NSInteger rotation;
///// 切片大小级别1-10. 切片大小为sliceLevel * 1024
//@property (nonatomic,assign) NSInteger sliceLevel;
@end

NS_ASSUME_NONNULL_END
