//
//  ViewController.m
//  AR-OTS
//
//  Created by 钟武 on 2017/11/14.
//  Copyright © 2017年 钟武. All rights reserved.
//

#import "LiveCameraViewController.h"
#import "CameraView.h"
#import "UIView+ZWUtility.h"

@interface LiveCameraViewController ()

@property (nonatomic, strong) CameraView *cameraView;

@end

@implementation LiveCameraViewController

#pragma mark - Controller View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.cameraView startCapture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.cameraView stopCapture];
}

#pragma mark - View Initialize

- (void)initializeView{
    self.cameraView = ({
        CameraView *cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [self.view addSubview:cameraView];
        
        cameraView;
    });
}

@end
