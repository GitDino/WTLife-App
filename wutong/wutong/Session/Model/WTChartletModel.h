//
//  WTChartletModel.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/8.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#define WTData @"data"
#define WTType @"WTMessageType"
#define WTCatalog @"catalog"
#define WTChartlet @"chartlet"

#import <Foundation/Foundation.h>

@interface WTChartletModel : NSObject <NIMCustomAttachment>

@property (nonatomic, copy) NSString *chartletID;

@property (nonatomic, copy) NSString *chartletCatalog;

@property (nonatomic, strong) UIImage *chartletImage;

@end
