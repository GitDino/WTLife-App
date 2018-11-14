//
//  WTFileLocationHelper.h
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTFileLocationHelper : NSObject

+ (NSString *)obtainAppDocumentPath;

+ (NSString *)obtainAppTempPath;

+ (NSString *)obtainUserDirectory;

+ (NSString *)genFileNameWithExt:(NSString *)ext;

+ (NSString *)filePathForVideo:(NSString *)fileName;

+ (NSString *)filePathForImage:(NSString *)fileName;

@end
