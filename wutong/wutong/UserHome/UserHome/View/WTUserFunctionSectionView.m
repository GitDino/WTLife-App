//
//  WTUserFunctionSectionView.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserFunctionSectionView.h"
#import "WTTagModel.h"

@interface WTUserFunctionSectionView ()

@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WTUserFunctionSectionView

+ (instancetype)userFunctionSectionView
{
    WTUserFunctionSectionView *sectionView = [[WTUserFunctionSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
    return sectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor wtWhiteColor];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, 1.0)];
        _lineView.backgroundColor = [UIColor wtLightGrayColor];
        [self addSubview:_lineView];
        
        for (int i = 0; i < 2; i ++)
        {
            UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * (SCREEN_WIDTH / 2.0), 0, SCREEN_WIDTH / 2.0, 35)];
            functionBtn.tag = i + 1;
            functionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [functionBtn setTitleColor:[UIColor wtBlackColor] forState:UIControlStateNormal];
            [functionBtn setTitleColor:[UIColor wtAppColor] forState:UIControlStateSelected];
            [self addSubview:functionBtn];
            [functionBtn addTarget:self action:@selector(onTapTagAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * 0.5 - 60) * 0.5, 35, 60, 2)];
        _selectedView.backgroundColor = [UIColor wtAppColor];
        [self addSubview:_selectedView];
    }
    return self;
}

- (void)onTapTagAction:(UIButton *)tagBtn
{
    self.selectedBtn.selected = !self.selectedBtn;
    tagBtn.selected = !tagBtn.selected;
    self.selectedBtn = tagBtn;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedView.frame = CGRectMake((CGRectGetWidth(tagBtn.frame) - 60) / 2 + (tagBtn.tag - 1) * CGRectGetWidth(tagBtn.frame), 35, 60, 2);
    }];
    
    for (WTTagModel *tagModel in self.sectionTagArray)
    {
        tagModel.selected = NO;
    }
    
    WTTagModel *tagModel = self.sectionTagArray[tagBtn.tag - 1];
    tagModel.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(onTapFunctionWithTag:)])
    {
        [self.delegate onTapFunctionWithTag:tagBtn.tag];
    }
}

- (void)setSectionTagArray:(NSArray *)sectionTagArray
{
    _sectionTagArray = sectionTagArray;
    
    for (int i = 0; i < _sectionTagArray.count; i ++)
    {
        WTTagModel *tagModel = _sectionTagArray[i];
        UIButton *functionBtn = (UIButton *)[self viewWithTag:i + 1];
        [functionBtn setTitle:tagModel.tagName forState:UIControlStateNormal];
        functionBtn.selected = tagModel.selected;
        if (tagModel.selected)
        {
            _selectedView.frame = CGRectMake((CGRectGetWidth(functionBtn.frame) - 60) / 2 + i * CGRectGetWidth(functionBtn.frame), CGRectGetMaxY(functionBtn.frame), 60, 2.0);
        }
    }
}

@end
