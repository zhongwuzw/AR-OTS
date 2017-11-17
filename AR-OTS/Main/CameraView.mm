//
//  CameraView.m
//  AR-OTS
//
//  Created by 钟武 on 2017/11/15.
//  Copyright © 2017年 钟武. All rights reserved.
//

#ifdef __cplusplus

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/face.hpp>
#import <vector>

#pragma clang pop

#endif

#import "CameraView.h"
#import "UIImage+OpenCV.h"

@interface CameraView () <CvVideoCameraDelegate>

@property (nonatomic, assign, readonly) CGFloat scale;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) cv::CascadeClassifier faceDetector;
@property (nonatomic, assign) std::vector<cv::Rect> faceRects;
@property (nonatomic, assign) std::vector<cv::Mat> faceImgs;
@property (nonatomic, strong) CvVideoCamera *videoCamera;

@end

@implementation CameraView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeCamera];
    }
    return self;
}

- (void)initializeCamera{
    
}

#pragma mark - Property

- (CGFloat)scale{
    return [UIScreen mainScreen].scale;
}

- (CvVideoCamera *)videoCamera{
    if (!_videoCamera) {
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:self];
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        _videoCamera.defaultFPS = 30;
        _videoCamera.grayscaleMode = NO;
        _videoCamera.delegate = self;
        
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
        _faceDetector.load(faceCascadePath.UTF8String);
    }
    return _videoCamera;
}

#pragma mark - Capture Operation

- (void)startCapture{
    [self.videoCamera start];
}

- (void)stopCapture{
    [self.videoCamera stop];
}

#pragma mark - Faces Detect

- (NSArray *)detectedFaces{
    NSMutableArray *facesArray = [NSMutableArray array];
    CGFloat scale = self.scale;
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++ )
    {
        // inforation from AVCaptureSessionPreset640x480 in videoCamera getter method
        CGRect faceRect = CGRectMake(scale*r->x/480., scale*r->y/640., scale*r->width/480., scale*r->height/640.);
        [facesArray addObject:[NSValue valueWithCGRect:faceRect]];
    }
    return [facesArray copy];
}

- (UIImage *)faceWithIndex:(NSInteger)idx{
    
    cv::Mat img = self->_faceImgs[idx];
    
    UIImage *ret = [UIImage imageFromCVMat:img];
    
    return ret;
}

- (void)detectAndDrawFacesOn:(cv::Mat&)img{
    int i = 0;
    CGFloat scale = self.scale;
    
    const static cv::Scalar colors[] =  { CV_RGB(0,0,255),
        CV_RGB(0,128,255),
        CV_RGB(0,255,255),
        CV_RGB(0,255,0),
        CV_RGB(255,128,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,0,255)} ;
    cv::Mat gray, smallImg( cvRound (img.rows/scale), cvRound(img.cols/scale), CV_8UC1 );
    
    cvtColor( img, gray, cv::COLOR_BGR2GRAY );
    resize( gray, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR );
    equalizeHist( smallImg, smallImg );
    
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30,30);
    
    self.faceDetector.detectMultiScale( smallImg, self->_faceRects,
                                         scalingFactor, minRects, 0,
                                         minSize );

    std::vector<cv::Mat> faceImages;
    
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++, i++ )
    {
        cv::Mat smallImgROI;
        cv::Point center;
        cv::Scalar color = colors[i%8];
        std::vector<cv::Rect> nestedObjects;
        rectangle(img,
                  cvPoint(cvRound(r->x*scale), cvRound(r->y*scale)),
                  cvPoint(cvRound((r->x + r->width-1)*scale), cvRound((r->y + r->height-1)*scale)),
                  color, 1, 8, 0);
        
        smallImgROI = smallImg(*r);
        
        faceImages.push_back(smallImgROI.clone());
    }
    
    @synchronized(self) {
        self->_faceImgs = faceImages;
    }
    
}

#pragma mark - CvVideoCameraDelegate

#ifdef __cplusplus
// delegate method for processing image frames
- (void)processImage:(cv::Mat&)image{
    [self detectAndDrawFacesOn:image];
}
#endif

@end
