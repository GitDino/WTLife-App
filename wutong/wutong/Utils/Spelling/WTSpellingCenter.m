//
//  WTSpellingCenter.m
//  wutong
//
//  Created by 魏欣宇 on 2018/9/19.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTSpellingCenter.h"
#import "WTPinyinConverter.h"

#define SPELLING_UNIT_FULLSPELLING          @"f"
#define SPELLING_UNIT_SHORTSPELLING         @"s"
#define SPELLING_CACHE                      @"sc"

@implementation SpellingUnit

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_fullSpelling forKey:SPELLING_UNIT_FULLSPELLING];
    [aCoder encodeObject:_shortSpelling forKey:SPELLING_UNIT_SHORTSPELLING];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.fullSpelling = [aDecoder decodeObjectForKey:SPELLING_UNIT_FULLSPELLING];
        self.shortSpelling = [aDecoder decodeObjectForKey:SPELLING_UNIT_SHORTSPELLING];
    }
    return self;
}

@end

@interface WTSpellingCenter ()
- (SpellingUnit *)calcSpellingOfString:(NSString *)source;
@end

@implementation WTSpellingCenter

+ (WTSpellingCenter *)sharedCenter
{
    static WTSpellingCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTSpellingCenter alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *appDocumentPath= [[NSString alloc] initWithFormat:@"%@/",[paths objectAtIndex:0]];
        _filePath = [appDocumentPath stringByAppendingString:SPELLING_CACHE];
        
        _spellingCache = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath])
        {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:_filePath];
            if ([dict isKindOfClass:[NSDictionary class]])
            {
                _spellingCache = [[NSMutableDictionary alloc]initWithDictionary:dict];
            }
        }
        if (!_spellingCache)
        {
            _spellingCache = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)saveSpellingCache
{
    static const NSInteger kMaxEntriesCount = 5000;
    @synchronized (self)
    {
        NSInteger count = [_spellingCache count];
        NSLog(@"Spelling Cache Entries %zd", count);
        if (count >= kMaxEntriesCount)
        {
            NSLog(@"Clear Spelling Cache %zd Entries", count);
            [_spellingCache removeAllObjects];
        }
        if (_spellingCache)
        {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_spellingCache];
            [data writeToFile:_filePath atomically:YES];
        }
    }
}

- (SpellingUnit *)spellingForString:(NSString *)source
{
    if ([source length] == 0)
    {
        return nil;
    }
    SpellingUnit *spellingUnit = nil;
    @synchronized (self)
    {
        SpellingUnit *unit = [_spellingCache objectForKey:source];
        if (!unit)
        {
            unit = [self calcSpellingOfString:source];
            if ([unit.fullSpelling length] && [unit.shortSpelling length])
            {
                [_spellingCache setObject:unit forKey:source];
            }
        }
        spellingUnit = unit;
    }
    return spellingUnit;
}

- (NSString *)firstLetter:(NSString *)input
{
    SpellingUnit *unit = [self spellingForString:input];
    NSString *spelling = unit.fullSpelling;
    return [spelling length] ? [spelling substringWithRange:NSMakeRange(0, 1)] : nil;
}

- (SpellingUnit *)calcSpellingOfString:(NSString *)source
{
    NSMutableString *fullSpelling = [[NSMutableString alloc]init];
    NSMutableString *shortSpelling= [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < [source length]; i++)
    {
        NSString *word = [source substringWithRange:NSMakeRange(i, 1)];
        NSString *pinyin = [[WTPinyinConverter sharedInstance] toPinyin:word];
        
        if ([pinyin length])
        {
            [fullSpelling appendString:pinyin];
            [shortSpelling appendString:[pinyin substringToIndex:1]];
        }
    }
    
    SpellingUnit *unit = [[SpellingUnit alloc]init];
    unit.fullSpelling = [fullSpelling lowercaseString];
    unit.shortSpelling= [shortSpelling lowercaseString];
    return unit;
}

@end
