//
//  CovertVideoToImage.m
//  SFIntegration
//
//  Created by Sean on 2023/11/4.
//

#import "CovertVideoToImage.h"
#import <UIKit/UIKit.h>
@implementation CovertVideoToImage
// Create a UIImage from sample buffer data
+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer fitToSize:(CGSize)size
{
    
    // 获取视频帧的 CVImageBufferRef 对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
    // 锁定基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 创建一个 CIImage 对象，使用 CVImageBufferRef 对象的基地址
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    // 解锁基地址
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    // 创建一个 CIFilter 对象，使用 CIGaussianBlur 滤镜
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    // 设置滤镜的输入图像为 CIImage 对象
//    [filter setValue:ciImage forKey:kCIInputImageKey];
//    // 设置滤镜的模糊半径为 10
//    [filter setValue:@10 forKey:kCIInputRadiusKey];
    // 获取滤镜的输出图像
//    CIImage *outputImage = filter.outputImage;
//    CIImage *outputImage = [CovertVideoToImage image:ciImage fitToSize:size];
    CIImage *outputImage = [ciImage imageByApplyingOrientation:kCGImagePropertyOrientationRight];
    outputImage = [CovertVideoToImage image:outputImage fitToSize:size];

//    [outputImage imageByCroppingToRect:CGRectMake(0, 0, 500, 500)];
    // 创建一个 CIContext 对象，使用默认选项
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建一个 CGImageRef 对象，使用 CIContext 对象将 CIImage 对象渲染为 CGImageRef 对象
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    // 创建一个 UIImage 对象，使用 CGImageRef 对象
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    // 释放 CGImageRef 对象
    CGImageRelease(cgImage);
    // 返回 UIImage 对象
    return uiImage;
}

+ (CIImage *)image:(CIImage *)image fitToSize:(CGSize)size {
    
    // 获取原始图像的宽高
    CGFloat imageWidth = image.extent.size.width;
    CGFloat imageHeight = image.extent.size.height;
    // 获取目标尺寸的宽高
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    // 计算缩放比例
    CGFloat scaleWidth = targetWidth / imageWidth;
    CGFloat scaleHeight = targetHeight / imageHeight;
    // 创建一个 CIImage 对象，用于存储缩放后的图像
    CIImage *scaledImage = nil;
    // 创建一个 CIImage 对象，用于存储裁剪后的图像
    CIImage *croppedImage = nil;
    // 判断适配方法
    if (scaleWidth > scaleHeight) {
        // 如果缩放宽度和目标宽度一致，高度的多余部分裁剪掉
        // 使用 CILanczosScaleTransform 滤镜来缩放图像
        CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        // 设置滤镜的输入图像为原始图像
        [scaleFilter setValue:image forKey:kCIInputImageKey];
        // 设置滤镜的缩放比例为宽度的缩放比例
        [scaleFilter setValue:@(scaleWidth) forKey:kCIInputScaleKey];
        // 设置滤镜的缩放方向为 1
        [scaleFilter setValue:@1 forKey:kCIInputAspectRatioKey];
        // 获取滤镜的输出图像
        scaledImage = scaleFilter.outputImage;
        // 使用 imageByCroppingToRect: 方法来裁剪图像
        // 计算裁剪矩形的 x 坐标，为 0
        CGFloat cropX = 0;
        // 计算裁剪矩形的 y 坐标，为 (缩放后的高度 - 目标高度) / 2
        CGFloat cropY = (imageHeight * scaleWidth - targetHeight) / 2;
        // 计算裁剪矩形的宽度，为目标宽度
        CGFloat cropWidth = targetWidth;
        // 计算裁剪矩形的高度，为目标高度
        CGFloat cropHeight = targetHeight;
        // 创建一个裁剪矩形
        CGRect cropRect = CGRectMake(cropX, cropY, cropWidth, cropHeight);
        // 调用 imageByCroppingToRect: 方法来裁剪图像
        croppedImage = [scaledImage imageByCroppingToRect:cropRect];
    } else {
        // 如果缩放高度和目标高度一致，宽度的多余部分裁剪掉
        // 使用 CILanczosScaleTransform 滤镜来缩放图像
        CIFilter *scaleFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
        // 设置滤镜的输入图像为原始图像
        [scaleFilter setValue:image forKey:kCIInputImageKey];
        // 设置滤镜的缩放比例为高度的缩放比例
        [scaleFilter setValue:@(scaleHeight) forKey:kCIInputScaleKey];
        // 设置滤镜的缩放方向为 1
        [scaleFilter setValue:@1 forKey:kCIInputAspectRatioKey];
        // 获取滤镜的输出图像
        scaledImage = scaleFilter.outputImage;
        // 使用 imageByCroppingToRect: 方法来裁剪图像
        // 计算裁剪矩形的 x 坐标，为 (缩放后的宽度 - 目标宽度) / 2
        CGFloat cropX = (imageWidth * scaleHeight - targetWidth) / 2;
        // 计算裁剪矩形的 y 坐标，为 0
        CGFloat cropY = 0;
        // 计算裁剪矩形的宽度，为目标宽度
        CGFloat cropWidth = targetWidth;
        // 计算裁剪矩形的高度，为目标高度
        CGFloat cropHeight = targetHeight;
        // 创建一个裁剪矩形
        CGRect cropRect = CGRectMake(cropX, cropY, cropWidth, cropHeight);
        // 调用 imageByCroppingToRect: 方法来裁剪图像
        croppedImage = [scaledImage imageByCroppingToRect:cropRect];
    }
    // 返回裁剪后的图像
    return croppedImage;
}
@end
