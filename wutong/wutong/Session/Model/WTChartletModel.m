//
//  WTChartletModel.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTChartletModel.h"

@implementation WTChartletModel

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{WTType : @(3),
                           WTData : @{WTCatalog : self.chartletCatalog ? self.chartletCatalog : @"",
                                      WTChartlet : self.chartletID ? self.chartletID : @""
                                      }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    
    NSString *content = nil;
    if (data)
    {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

@end
