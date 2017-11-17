//
//  UIImage+OpenCV.h
//  AR-OTS
//
//  Created by 钟武 on 2017/11/16.
//  Copyright © 2017年 钟武. All rights reserved.
//

#ifdef __cplusplus

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#import <opencv2/opencv.hpp>

#pragma clang pop

#endif

#import <UIKit/UIKit.h>

@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;

- (cv::Mat)cvMatRepresentationColor;
- (cv::Mat)cvMatRepresentationGray;

@end
