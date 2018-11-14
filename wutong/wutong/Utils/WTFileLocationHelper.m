//
//  WTFileLocationHelper.m
//  ChatBoxDemo
//
//  Created by 魏欣宇 on 2018/7/9.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTFileLocationHelper.h"

@interface WTFileLocationHelper ()

+ (NSString *)filePathForDict:(NSString *)dictName fileName:(NSString *)fileName;

@end

@implementation WTFileLocationHelper

#pragma mark - Public Cycle
+ (NSString *)obtainAppDocumentPath
{
    static NSString *appDocumentPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *appKey = NIM_AppKey;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDocumentPath = [[NSString alloc]initWithFormat:@"%@/%@/", [paths objectAtIndex:0], appKey];
        if (![[NSFileManager defaultManager] fileExistsAtPath:appDocumentPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:appDocumentPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        [WTFileLocationHelper addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:appDocumentPath]];
    });
    return appDocumentPath;
}

+ (NSString *)obtainAppTempPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)obtainUserDirectory
{
    NSString *documentPath = [WTFileLocationHelper obtainAppDocumentPath];
    NSString *userID = [NIMSDK sharedSDK].loginManager.currentAccount;
    if ([userID length] == 0)
    {
        NSLog(@"Error: Get User Directory While UserID Is Empty");
    }
    NSString* userDirectory= [NSString stringWithFormat:@"%@%@/", documentPath, userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
    }
    return userDirectory;
}

+ (NSString *)filePathForVideo:(NSString *)fileName
{
    return [WTFileLocationHelper filePathForDict:@"video" fileName:fileName];
}

+ (NSString *)filePathForImage:(NSString *)fileName
{
    return [WTFileLocationHelper filePathForDict:@"image" fileName:fileName];
}

+ (NSString *)genFileNameWithExt:(NSString *)ext
{
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@", uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@.%@",name,ext] : name;
}

#pragma mark - Private Cycle
+ (NSString *)filePathForDict:(NSString *)dictName fileName:(NSString *)fileName
{
    return [[WTFileLocationHelper resourceDict:dictName] stringByAppendingPathComponent:fileName];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (success)
    {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (NSString *)resourceDict:(NSString *)resouceName
{
    NSString *dict = [[WTFileLocationHelper obtainUserDirectory] stringByAppendingPathComponent:resouceName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dict])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dict
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    return dict;
}

@end
