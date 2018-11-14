//
//  WTBubbleImageView.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTBubbleImageView.h"

@interface WTBubbleImageView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation WTBubbleImageView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUserInteractionEnabled:YES];
        
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressAction:)];
        _longPress.minimumPressDuration = 0.8;
        [self addGestureRecognizer:_longPress];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image])
    {
        self.userInteractionEnabled = YES;
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copyText:"] || [NSStringFromSelector(action) isEqualToString:@"revokeMessage:"] || [NSStringFromSelector(action) isEqualToString:@"deleteMsg:"])
    {
        return YES;
    }
    return NO;
}

#pragma mark - Private Cycle
- (NSArray *)menuItems
{
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"
                                                      action:@selector(copyText:)];
    UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回"
                                                    action:@selector(revokeMessage:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除"
                                                        action:@selector(deleteMsg:)];
    
    if (self.isSend)
    {
        return self.isCopy ? @[copyItem, revokeItem, deleteItem] : @[revokeItem, deleteItem];
    }
    else
    {
        return self.isCopy ? @[copyItem, deleteItem] : @[deleteItem];
    }
    
}

#pragma mark - Event Cycle
/**
 * 复制
 */
- (void)copyText:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onCopy)])
    {
        [self.delegate onCopy];
    }
}

/**
 * 撤回
 */
- (void)revokeMessage:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onRevoke)])
    {
        [self.delegate onRevoke];
    }
}

/**
 * 删除
 */
- (void)deleteMsg:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onDelete)])
    {
        [self.delegate onDelete];
    }
}

#pragma mark - Gesture Cycle
- (void)onLongPressAction:(UILongPressGestureRecognizer *)longGes
{
    if (longGes.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        menu.menuItems = [self menuItems];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)onTapAction
{
    if ([self.delegate respondsToSelector:@selector(onTouchUpInside)])
    {
        [self.delegate onTouchUpInside];
    }
}

@end
