//
//  WTScanCodeVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/1.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTScanCodeVC.h"
#import <SGQRCode.h>
#import <AVFoundation/AVFoundation.h>

@interface WTScanCodeVC ()

@property (nonatomic, strong) SGQRCodeObtain *obtain;
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;

@end

@implementation WTScanCodeVC

#pragma mark - Life Cycle
- (void)dealloc
{
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_stop)
    {
        [self.obtain startRunningWithBefore:^{
            
        } completion:^{
            
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

#pragma mark - Custom Cycle

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    self.navigationItem.title = @"扫一扫";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction)];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [self.obtain establishQRCodeObtainScanWithController:self configure:configure];
    [self.obtain startRunningWithBefore:^{
        
    } completion:^{
        
    }];
    [self.obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result)
        {
            [weakSelf.obtain stopRunning];
            weakSelf.stop = YES;
            [weakSelf.obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            if ([result containsString:@"wutonglife"])
            {
                if (weakSelf.codeCompleteBlock)
                {
                    weakSelf.codeCompleteBlock(result);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [WTProgressHUD showProgressInView:weakSelf.view message:@"该二维码非平台二维码"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }
    }];
}

- (void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonItemAction
{
    __weak typeof(self) weakSelf = self;
    
    [self.obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (self.obtain.isPHAuthorization == YES)
    {
        [self.scanView removeTimer];
    }
    [self.obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [self.obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil)
        {
            NSLog(@"暂未识别出二维码");
        }
        else
        {
            NSLog(@"%@", result);
            if ([result containsString:@"wutonglife"])
            {
                if (weakSelf.codeCompleteBlock)
                {
                    weakSelf.codeCompleteBlock(result);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [WTProgressHUD showProgressInView:weakSelf.view message:@"该二维码非平台二维码"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }
        }
    }];
}

- (void)removeScanningView
{
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

#pragma mark - Getter Cycle
- (SGQRCodeScanView *)scanView
{
    if (!_scanView)
    {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scanView.scanImageName = @"SGQRCode.bundle/QRCodeScanLineGrid";
        _scanView.scanAnimationStyle = ScanAnimationStyleGrid;
        _scanView.cornerColor = [UIColor orangeColor];
    }
    return _scanView;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel)
    {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * SCREEN_HEIGHT - 64;
        CGFloat promptLabelW = SCREEN_WIDTH;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}


@end
