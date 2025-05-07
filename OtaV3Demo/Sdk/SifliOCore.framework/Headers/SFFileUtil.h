//
//  SFFileUtil.h
//  SifliOCore
//
//  Created by Sean on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFResult.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFFileUtil : NSObject
+ (BOOL)isFileExist:(NSString *)filePath;
+ (BOOL)isDirectory:(NSString *)filePath;

/// 枚举一个目录下的所有文件，包含子目录
/// - Parameter fileDir: 目录
+ (NSArray<NSString *> *)listFilesInDir:(NSString *)fileDir;

+ (uint64_t)getFileDataLength:(NSString *)filePath;
+ (SFDataResult *)getFileData:(NSString *)filePath;

+ (SFDataResult *)getFileSliceData:(NSString *)filePath
                      offset:(uint64_t)offset
                 sliceLength:(NSUInteger)sliceLength;
+ (SFDataResult *)appendCRCWithFile:(NSString *)filePath padding:(uint8_t)padding;
+ (SFDataResult *) getMd5OfFile:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
