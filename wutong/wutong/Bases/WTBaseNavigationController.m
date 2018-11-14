//
//  WTBaseNavigationController.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/29.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBaseNavigationController.h"

@interface WTBaseNavigationController ()

@end

@implementation WTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage wtImageWithColor:[UIColor wtWhiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

@end
