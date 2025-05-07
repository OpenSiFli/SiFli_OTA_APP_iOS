//
//  SFFolderUtil.h
//  SifliOCore
//
//  Created by Sean on 2023/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFFolderUtil : NSObject

/// 创建一个临时目录，如果该目录存在则删除后重新创建
/// - Parameter dir: 目录名称
+ (NSString *)createTempDir:(NSString *)dir;
@end

NS_ASSUME_NONNULL_END
