//
//  WTUserFunctionSectionView.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTUserFunctionSectionViewDelegate <NSObject>

- (void)onTapFunctionWithTag:(NSInteger)functionTag;

@end

@interface WTUserFunctionSectionView : UIView

@property (nonatomic, weak) id<WTUserFunctionSectionViewDelegate> delegate;

@property (nonatomic, strong) NSArray *sectionTagArray;

+ (instancetype)userFunctionSectionView;

@end
