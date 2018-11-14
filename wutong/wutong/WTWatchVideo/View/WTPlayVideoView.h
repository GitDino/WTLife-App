//
//  WTPlayVideoView.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closePlayVideoBlock)(void);

@interface WTPlayVideoView : UIView

@property (nonatomic, copy) closePlayVideoBlock closePlayVideoBlock;

@property (nonatomic, copy) NSURL *videoURL;

- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView URL:(NSURL *)url;

@end
