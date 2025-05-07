//
//  SFResult.h
//  SifliOCore
//
//  Created by Sean on 2024/8/9.
//

#import <Foundation/Foundation.h>
#import <SifliOCore/SFCoreError.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFResult : NSObject
@property(nonatomic,assign)BOOL success;
@property(nonatomic,strong)SFCoreError *error;
- (instancetype)initWithSuccess:(BOOL)success error:(nullable SFCoreError *)error;
@end

@interface SFDataResult : SFResult
@property(nonatomic,strong)NSData *data;
- (instancetype)initWithSuccess:(BOOL)success data:(nullable NSData *)data error:(nullable SFCoreError *)error;
@end

NS_ASSUME_NONNULL_END
