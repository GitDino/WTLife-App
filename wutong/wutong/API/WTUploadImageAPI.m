//
//  WTUploadImageAPI.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/6.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUploadImageAPI.h"
#import <WTAppClient.h>

@implementation WTUploadImageAPI

+ (void)uploadImage:(UIImage *)picture resultBlock:(resultBlock)resultBlock
{
    [WTAppClient sharedClient].requestSerializer = [AFHTTPRequestSerializer serializer];
    [[WTAppClient sharedClient].requestSerializer setValue:[[WTAccountManager sharedManager] token] forHTTPHeaderField:@"token"];
    [WTAppClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [[WTAppClient sharedClient] POST:[BASE_URL stringByAppendingString:@"/img/upload"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(picture, 0.5);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"iOS_%@.jpg", dateString];
        [formData appendPartWithFileData:imageData name:@"picture" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        resultBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-----上传图片接口%@", error);
    }];
}

@end
