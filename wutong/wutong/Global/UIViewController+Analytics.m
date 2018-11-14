//
//  UIViewController+Analytics.m
//  TestDemo
//
//  Created by 魏欣宇 on 2018/5/13.
//  Copyright © 2018年 Dino. All rights reserved.
//

#import <objc/message.h>
#import "UIViewController+Analytics.h"
#import "TalkingData.h"

@implementation UIViewController (Analytics)

+ (void)load
{
    DO_changeMethod([self class], @selector(viewWillAppear:), @selector(DO_viewWillAppear:));
    DO_changeMethod([self class], @selector(viewWillDisappear:), @selector(DO_viewWillDisappear:));
}

/**
 互换方法实现
 
 @param class 类
 @param original_sel 原来的方法
 @param custom_sel 自定义方法
 */
void DO_changeMethod(Class class, SEL original_sel, SEL custom_sel)
{
    Method original_method = class_getInstanceMethod(class, original_sel);
    
    Method do_method = class_getInstanceMethod(class, custom_sel);
    
    BOOL isSuccess = class_addMethod(class, original_sel, method_getImplementation(do_method), method_getTypeEncoding(do_method));
    
    if (isSuccess)
    {
        class_addMethod(class, custom_sel, method_getImplementation(original_method), method_getTypeEncoding(original_method));
    }
    else
    {
        method_exchangeImplementations(original_method, do_method);
    }
}

/**
 自定义 viewWillAppear 方法
 */
- (void)DO_viewWillAppear:(BOOL)animated
{
    [self DO_viewWillAppear:animated];
    
    NSString *classStr = [NSString stringWithFormat:@"%@", self.class];
    if ([classStr containsString:@"WT"] && ![classStr containsString:@"BaseNavigation"])
    {
        if ([classStr containsString:@"WebViewVC"])
        {
            self.title = @"前端页面";
        }
        else if ([classStr containsString:@"GuidePage"])
        {
            self.title = @"引导页";
        }
        [TalkingData trackPageBegin:[NSString stringWithFormat:@"%@ (%@)", self.title, NSStringFromClass([self class])]];
    }
}

/**
 自定义 viewWillDisappear 方法
 */
- (void)DO_viewWillDisappear:(BOOL)animated
{
    [self DO_viewWillDisappear:animated];
    
    NSString *classStr = [NSString stringWithFormat:@"%@", self.class];
    if ([classStr containsString:@"WT"] && ![classStr containsString:@"BaseNavigation"])
    {
        if ([classStr containsString:@"WebViewVC"])
        {
            self.title = @"前端页面";
        }
        else if ([classStr containsString:@"GuidePage"])
        {
            self.title = @"引导页";
        }
        [TalkingData trackPageEnd:[NSString stringWithFormat:@"%@ (%@)", self.title, NSStringFromClass([self class])]];
    }
}

@end
