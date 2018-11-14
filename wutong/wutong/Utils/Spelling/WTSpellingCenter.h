//
//  WTSpellingCenter.h
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpellingUnit : NSObject <NSCoding>
@property (nonatomic, strong) NSString *fullSpelling;
@property (nonatomic, strong) NSString *shortSpelling;
@end

@interface WTSpellingCenter : NSObject

@property (nonatomic, strong) NSMutableDictionary *spellingCache;
@property (nonatomic, copy) NSString *filePath;

+ (WTSpellingCenter *)sharedCenter;
- (void)saveSpellingCache;

- (SpellingUnit *)spellingForString:(NSString *)source;
- (NSString *)firstLetter:(NSString *)input;

@end
