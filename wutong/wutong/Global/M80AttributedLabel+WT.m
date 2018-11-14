//
//  M80AttributedLabel+WT.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "M80AttributedLabel+WT.h"
#import "WTInputEmoticonParser.h"
#import "WTEmoticonManager.h"
#import <UIImage+IM.h>

@implementation M80AttributedLabel (WT)

- (void)wt_setText:(NSString *)text
{
    [self setText:@""];
    NSArray *tokens = [[WTInputEmoticonParser currentParser] tokens:text];
    for (WTInputTextToken *token in tokens)
    {
        if (token.type == WTInputTokenTypeEmoticon)
        {
            WTEmoticon *emoticon = [[WTEmoticonManager sharedManager] emoticonByTag:token.text];
            UIImage *image = [UIImage wt_emoticonInKit:emoticon.filename];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18) margin:UIEdgeInsetsZero alignment:M80ImageAlignmentCenter];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}

@end
