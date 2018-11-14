//
//  WTTagModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTTagModel : NSObject

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, assign) BOOL selected;

@end
