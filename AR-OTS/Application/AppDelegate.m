//
//  AppDelegate.m
//  AR-OTS
//
//  Created by 钟武 on 2017/11/14.
//  Copyright © 2017年 钟武. All rights reserved.
//

#import "AppDelegate.h"
#import "LiveCameraViewController.h"
#import "BaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    LiveCameraViewController *liveCameraVC = [LiveCameraViewController new];
    BaseNavigationController *navigationVC = [[BaseNavigationController alloc] initWithRootViewController:liveCameraVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navigationVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
