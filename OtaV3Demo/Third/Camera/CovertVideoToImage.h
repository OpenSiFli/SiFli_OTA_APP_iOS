//
//  CovertVideoToImage.h
//  SFIntegration
//
//  Created by Sean on 2023/11/4.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CovertVideoToImage : NSObject
+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer fitToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
