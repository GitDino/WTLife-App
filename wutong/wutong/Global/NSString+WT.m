//
//  NSString+WT.m
//  wutong
//
//  Created by 魏欣宇 on 2018/7/31.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "NSString+WT.h"

@implementation NSString (WT)

+ (BOOL)isBlankString:(NSString *)str
{
    if (str == nil || str == NULL)
    {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        return YES;
    }
    return NO;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:attrs context:NULL].size;
}

+ (NSArray *)getParamsWithUrlString:(NSString *)urlString
{
    if(urlString.length == 0)
    {
        NSLog(@"链接为空！");
        return @[@"", @{}];
    }
    //先截取问号
    NSArray *allElements = [urlString componentsSeparatedByString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//待set的参数字典
    if(allElements.count==2)
    {
        //有参数或者?后面为空
        NSString *myUrlString = allElements[0];
        NSString *paramsString = allElements[1];
        //获取参数对
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count >= 2)
        {
            for(NSInteger i =0; i < paramsArray.count; i++)
            {
                NSString *singleParamString = paramsArray[i];
                NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count==2)
                {
                    NSString *key = singleParamSet[0];
                    NSString *value = singleParamSet[1];
                    if(key.length>0|| value.length>0)
                    {
                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                    }
                }
            }
        }
        else if(paramsArray.count==1)
        {
            //无 &。url只有?后一个参数
            NSString *singleParamString = paramsArray[0];
            NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count==2)
            {
                NSString *key = singleParamSet[0];
                NSString *value = singleParamSet[1];
                if(key.length > 0 || value.length > 0)
                {
                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                }
            }
            else{}//问号后面啥也没有 xxxx?  无需处理
        }
        //整合url及参数
        return@[myUrlString, params];
    }
    else if(allElements.count > 2)
    {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @[@"",@{}];
    }
    else
    {
        NSLog(@"链接不包含参数！");
        return@[urlString,@{}];
    }
}

@end
