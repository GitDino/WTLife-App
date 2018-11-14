//
//  WTPlayVideoVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTPlayVideoVC.h"
#import "WTPlayVideoView.h"

@interface WTPlayVideoVC ()

@property (nonatomic, strong) WTPlayVideoView *playVideo;

@property (nonatomic, strong) UIImageView *coverImage;

@end

@implementation WTPlayVideoVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor wtBlackColor];
    [self configSubViews];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath])
    {
        self.playVideo = [[WTPlayVideoView alloc] initWithFrame:self.view.bounds withShowInView:self.view URL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", self.videoPath]]];
    }
    else
    {
        [[NIMSDK sharedSDK].resourceManager download:self.videoURL filepath:self.videoPath progress:^(float progress) {
            [WTProgressHUD showHUDInView:self.view];
        } completion:^(NSError * _Nullable error) {
            [WTProgressHUD hideHUDForView:self.view];
            if (!error)
            {
                self.playVideo = [[WTPlayVideoView alloc] initWithFrame:self.view.bounds withShowInView:self.view URL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", self.videoPath]]];
            }
            else
            {
                [WTProgressHUD showProgressInView:self.view message:@"下载出错，请返回重新播放"];
            }
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    self.playVideo.closePlayVideoBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

#pragma mark - Private Cycle
- (void)configSubViews
{
    self.coverImage.image = [UIImage imageWithContentsOfFile:self.imageCoverPath];
    [self.view addSubview:self.coverImage];
}

#pragma mark - Getter Cycle
- (UIImageView *)coverImage
{
    if (!_coverImage)
    {
        _coverImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _coverImage;
}

@end
