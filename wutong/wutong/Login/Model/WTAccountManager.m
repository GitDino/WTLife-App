//
//  WTAccountManager.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/4.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTAccountManager.h"
#import <UMPush/UMessage.h>

@implementation WTUser
MJCodingImplementation

@end

@interface WTAccountManager ()
@property (nonatomic, copy) NSString *filePath;
@end

NSString *Token_Key = @"tokenKey";
@implementation WTAccountManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager
{
    static WTAccountManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[WTFileLocationHelper obtainAppDocumentPath] stringByAppendingPathComponent:@"wutong_account_data"];
        sharedManager = [[WTAccountManager alloc] initWithPath:filePath];
    });
    return sharedManager;
}

- (instancetype)initWithPath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = filePath;
        _token = [[NSUserDefaults standardUserDefaults] valueForKey:Token_Key];
        [self readData];
    }
    return self;
}

#pragma mark - Private Cycle
- (void)readData
{
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _currentUser = [object isKindOfClass:[WTUser class]] ? object : nil;
    }
}

- (void)saveData
{
    NSData *data = [NSData data];
    if (_currentUser)
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentUser];
    }
    [data writeToFile:[self filePath] atomically:YES];
}

#pragma mark - Getter Cycle
- (void)setCurrentUser:(WTUser *)currentUser
{
    _currentUser = currentUser;
    if (_currentUser)
    {
        //友盟绑定
        [UMessage setAlias:[NSString stringWithFormat:@"user_%@", _currentUser.uid] type:@"user" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"-----友盟绑定%@", error);
        }];
        [self saveData];
    }
    else
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        }
    }
}

- (void)setToken:(NSString *)token
{
    _token = token;
    if (_token.length)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_token forKey:Token_Key];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:Token_Key];
    }
}

@end
