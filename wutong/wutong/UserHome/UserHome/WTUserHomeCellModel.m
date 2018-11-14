//
//  WTUserHomeCellModel.m
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTUserHomeCellModel.h"
#import "WTUserInfoModel.h"
#import "WTUserPictureModel.h"
#import "WTTagModel.h"
#import "WTUserOrderModel.h"
#import "WTGoodsModel.h"

#define Padding 12

@implementation WTUserHomeCellModel

- (instancetype)init
{
    if (self = [super init])
    {
        _startsFrameArray = [NSMutableArray array];
        _systemTagsFrameArray = [NSMutableArray array];
        _customTagsFrameArray = [NSMutableArray array];
    }
    return self;
}

+ (NSArray *)obtainUserHomeCellModelsWithUserInfoModel:(WTUserInfoModel *)infoModel userPictureModel:(WTUserPictureModel *)pictureModel userOrderModelArray:(NSArray *)orderModelArray functionTag:(NSInteger)functionTag
{
    NSMutableArray *cellModelArray = [NSMutableArray array];
    
    WTUserHomeCellModel *cellModel1 = [[WTUserHomeCellModel alloc] init];
    cellModel1.className = @"WTHeadIconCell";
    
    cellModel1.cellIcon = infoModel.img;
    cellModel1.iconFrame = CGRectMake(10, 18, 78, 78);
    
    cellModel1.cellName = infoModel.nickname;
    CGSize nameSize = [NSString sizeWithText:infoModel.nickname font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 114, MAXFLOAT)];
    cellModel1.nameFrame = CGRectMake(CGRectGetMaxX(cellModel1.iconFrame) + 16, 18 + (78 - nameSize.height) * 0.5, nameSize.width, nameSize.height);
    
    cellModel1.cellSex = infoModel.sex;
    cellModel1.sexFrame = CGRectMake(CGRectGetMaxX(cellModel1.nameFrame) + 6, CGRectGetMinY(cellModel1.nameFrame), 20, 20);
    
//    cellModel1.cellPlaceholer = infoModel.shopName;
    CGSize placeholderSize = [NSString sizeWithText:cellModel1.cellPlaceholer font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH - 114, 44)];
    cellModel1.placeholderFrame = CGRectMake(CGRectGetMinX(cellModel1.nameFrame), CGRectGetMaxY(cellModel1.nameFrame) + 14, placeholderSize.width, placeholderSize.height);
    
    cellModel1.cellHeight = 114.0;
    
    [cellModelArray addObject:@[cellModel1]];
    
    WTUserHomeCellModel *cellModel2 = [[WTUserHomeCellModel alloc] init];
    cellModel2.className = @"WTInfoNormalCell";
    cellModel2.cellTitle = @"地区";
    cellModel2.titleFrame = CGRectMake(10, 13, 50, 20);
    cellModel2.cellContent = [NSString isBlankString:infoModel.cityName] ? @"未完善" : infoModel.cityName;
    cellModel2.contentFrame = CGRectMake(104, 13, SCREEN_WIDTH - 108 - 10, 20);
    cellModel2.cellHeight = 46.0;
    
    WTUserHomeCellModel *cellModel3 = [[WTUserHomeCellModel alloc] init];
    cellModel3.className = @"WTInfoNormalCell";
    cellModel3.cellTitle = @"个性签名";
    cellModel3.cellContent = [NSString isBlankString:infoModel.sign] ? @"未完善" : infoModel.sign;
    CGSize signSize = [NSString sizeWithText:cellModel3.cellContent font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 114, MAXFLOAT)];
    cellModel3.contentFrame = CGRectMake(104, 16, signSize.width, signSize.height);
    cellModel3.cellHeight = CGRectGetMaxY(cellModel3.contentFrame) + 16;
    cellModel3.titleFrame = CGRectMake(10, (cellModel3.cellHeight - 20) * 0.5, 60, 20);
    
    [cellModelArray addObject:@[cellModel2, cellModel3]];
    
    
    WTUserHomeCellModel *cellModel4 = [[WTUserHomeCellModel alloc] init];
    cellModel4.className = @"WTInfoNormalCell";
    cellModel4.cellTitle = @"设置备注名和电话";
    cellModel4.titleFrame = CGRectMake(10, 13, 150, 20);
    cellModel4.cellHeight = 46.0;
    
    WTUserHomeCellModel *cellModel5 = [[WTUserHomeCellModel alloc] init];
    cellModel5.className = @"WTInfoNormalCell";
    cellModel5.cellTitle = @"电话号码";
    cellModel5.titleFrame = CGRectMake(10, 13, 80, 20);
    cellModel5.cellContent = infoModel.remtel;
    cellModel5.contentFrame = CGRectMake(104, 13, SCREEN_WIDTH - 108 - 10, 20);
    cellModel5.cellHeight = 46.0;
    
    if (![NSString isBlankString:infoModel.remtel])
    {
        [cellModelArray addObject:@[cellModel4, cellModel5]];
    }
    else
    {
        [cellModelArray addObject:@[cellModel4]];
    }
    
    WTUserHomeCellModel *cellModel6 = [[WTUserHomeCellModel alloc] init];
    cellModel6.className = @"WTUserPictureCell";
    
    cellModel6.cellRegisterTime = [NSString stringWithFormat:@"注册时间        %@", [pictureModel.createTime substringToIndex:10]];
    cellModel6.cellRegisterTimeFrame = CGRectMake(10, 14, (SCREEN_WIDTH - 30) * 0.5, 15);
    
    cellModel6.cellLatestPayTime = [NSString stringWithFormat:@"最近消费时间     %@", [NSString isBlankString:pictureModel.lastDate] ? @"近期未消费" : pictureModel.lastDate];
    cellModel6.cellLatestPayTimeFrame = CGRectMake(CGRectGetMaxX(cellModel6.cellRegisterTimeFrame) + 10, CGRectGetMinY(cellModel6.cellRegisterTimeFrame), CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellTotalPayAmmount = [NSString stringWithFormat:@"消费总金额    %@元", pictureModel.totalAmount];
    cellModel6.cellTotalPayAmmountFrame = CGRectMake(CGRectGetMinX(cellModel6.cellRegisterTimeFrame), CGRectGetMaxY(cellModel6.cellRegisterTimeFrame) + 10, CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellDayMaxAmmount = [NSString stringWithFormat:@"单日最高            %@元", pictureModel.dayMax];
    cellModel6.cellDayMaxAmmountFrame = CGRectMake(CGRectGetMinX(cellModel6.cellLatestPayTimeFrame), CGRectGetMinY(cellModel6.cellTotalPayAmmountFrame), CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellRepeatBuyNumber = [NSString stringWithFormat:@"复购单数        %zd次", pictureModel.totalBuy];
    cellModel6.cellRepeatBuyNumberFrame = CGRectMake(CGRectGetMinX(cellModel6.cellRegisterTimeFrame), CGRectGetMaxY(cellModel6.cellTotalPayAmmountFrame) + 10, CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellPerMaxAmmount = [NSString stringWithFormat:@"单品最高            %@元", pictureModel.max];
    cellModel6.cellPerMaxAmmountFrame = CGRectMake(CGRectGetMinX(cellModel6.cellLatestPayTimeFrame), CGRectGetMaxY(cellModel6.cellDayMaxAmmountFrame) + 10, CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellPerOrderAmmount = [NSString stringWithFormat:@"客单价            %@元/单", pictureModel.perOrder];
    cellModel6.cellPerOrderAmmountFrame = CGRectMake(CGRectGetMinX(cellModel6.cellRegisterTimeFrame), CGRectGetMaxY(cellModel6.cellRepeatBuyNumberFrame) + 10, CGRectGetWidth(cellModel6.cellRegisterTimeFrame), 15);
    
    cellModel6.cellHeight = CGRectGetMaxY(cellModel6.cellPerOrderAmmountFrame) + 14;
    
    WTUserHomeCellModel *cellModel7 = [[WTUserHomeCellModel alloc] init];
    cellModel7.isSystem = YES;
    cellModel7.className = @"WTUserTagCell";
    cellModel7.cellSystemTitle = @"系统标签";
    cellModel7.cellSystemTitleFrame = CGRectMake(10, 14, SCREEN_WIDTH - 20, 15);
    cellModel7.systemTagArray = pictureModel.sysTag;

    if (pictureModel.sysTag.count)
    {
        CGFloat w = 0;
        CGFloat h = w;
        CGFloat lastTagY = 0;
        for (int i = 0; i < pictureModel.sysTag.count; i ++)
        {
            WTTagModel *tagModel = pictureModel.sysTag[i];
            CGSize tagSize = [NSString sizeWithText:tagModel.tagName font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGRect tagF = CGRectMake(w + Padding * 0.5, h, tagSize.width + 20, tagSize.height + 14);
            if (w + tagSize.width + 20 > SCREEN_WIDTH - Padding * 2)
            {
                w = 0;
                h = h + tagSize.height + 20;
                tagF = CGRectMake(w + Padding * 0.5, h, tagSize.width + 20, tagSize.height + 14);
            }
            if (tagSize.width + 20 > SCREEN_WIDTH - Padding * 2)
            {
                tagF = CGRectMake(CGRectGetMinX(tagF), CGRectGetMinY(tagF), SCREEN_WIDTH - Padding, tagSize.height + 14);
            }
            w = CGRectGetWidth(tagF) + CGRectGetMinX(tagF);
            if (i == pictureModel.sysTag.count - 1)
            {
                lastTagY = CGRectGetMaxY(tagF);
                cellModel7.systemTagViewFrame = CGRectMake(Padding - 6, CGRectGetMaxY(cellModel7.cellSystemTitleFrame) + 10, SCREEN_WIDTH - Padding, lastTagY);
            }
            NSValue *tagValue = [NSValue valueWithCGRect:tagF];
            [cellModel7.systemTagsFrameArray addObject:tagValue];
        }
        cellModel7.cellHeight = CGRectGetMaxY(cellModel7.systemTagViewFrame) + 14;
    }
    else
    {
        cellModel7.cellHeight = CGRectGetMaxY(cellModel7.cellSystemTitleFrame) + 14;
    }
    
    WTUserHomeCellModel *cellModel8 = [[WTUserHomeCellModel alloc] init];
    cellModel8.className = @"WTUserTagCell";
    cellModel8.cellCustomTitle = @"我打的标签";
    cellModel8.cellCustomTitleFrame = CGRectMake(10, 14, SCREEN_WIDTH - 110, 15);
    cellModel8.addCustomTagBtnFrame = CGRectMake(SCREEN_WIDTH - 90, 0, 80, 43);
    cellModel8.customTagArray = pictureModel.defTags;
    
    if (pictureModel.defTags.count)
    {
        CGFloat w = 0;
        CGFloat h = w;
        CGFloat lastTagY = 0;
        for (int i = 0; i < pictureModel.defTags.count; i ++)
        {
            WTTagModel *tagModel = pictureModel.defTags[i];
            CGSize tagSize = [NSString sizeWithText:tagModel.tagName font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            CGRect tagF = CGRectMake(w + Padding * 0.5, h, tagSize.width + 20, tagSize.height + 14);
            if (w + tagSize.width + 20 > SCREEN_WIDTH - Padding * 2)
            {
                w = 0;
                h = h + tagSize.height + 20;
                tagF = CGRectMake(w + Padding * 0.5, h, tagSize.width + 20, tagSize.height + 14);
            }
            if (tagSize.width + 20 > SCREEN_WIDTH - Padding * 2)
            {
                tagF = CGRectMake(CGRectGetMinX(tagF), CGRectGetMinY(tagF), SCREEN_WIDTH - Padding, tagSize.height + 14);
            }
            w = CGRectGetWidth(tagF) + CGRectGetMinX(tagF);
            if (i == pictureModel.defTags.count - 1)
            {
                lastTagY = CGRectGetMaxY(tagF);
                cellModel8.customTagViewFrame = CGRectMake(Padding - 6, CGRectGetMaxY(cellModel8.cellCustomTitleFrame) + 10, SCREEN_WIDTH - Padding, lastTagY);
            }
            NSValue *tagValue = [NSValue valueWithCGRect:tagF];
            [cellModel8.customTagsFrameArray addObject:tagValue];
        }
        cellModel8.cellHeight = CGRectGetMaxY(cellModel8.customTagViewFrame) + 14;
    }
    else
    {
        cellModel8.cellHeight = CGRectGetMaxY(cellModel8.cellCustomTitleFrame) + 14;
    }
    
    switch (functionTag) {
        case 1://用户画像
            [cellModelArray addObject:@[cellModel6, cellModel7, cellModel8]];
            break;
        case 2://历史订单
            {
                NSMutableArray *targetArray = [NSMutableArray array];
                for (WTUserOrderModel *orderModel in orderModelArray)
                {
                    WTUserHomeCellModel *cellModel = [[WTUserHomeCellModel alloc] init];
                    cellModel.className = @"WTUserOrderCell";
                    
                    cellModel.cellOrderTime = [NSString stringWithFormat:@"下单时间：%f", orderModel.createTime];
                    cellModel.cellOrderTimeFrmae = CGRectMake(10, 14, (SCREEN_WIDTH - 30) * 0.5, 15);
                    
                    cellModel.cellOrderInfo = [NSString stringWithFormat:@"共%zd件商品，实付：¥%@", orderModel.total, orderModel.totalAmount];
                    cellModel.cellOrderInfoFrame = CGRectMake(CGRectGetMaxX(cellModel.cellOrderTimeFrmae) + 10, CGRectGetMinY(cellModel.cellOrderTimeFrmae), CGRectGetWidth(cellModel.cellOrderTimeFrmae), 15);
                    
                    cellModel.lineViewFrame = CGRectMake(0, CGRectGetMaxY(cellModel.cellOrderInfoFrame) + 14, SCREEN_WIDTH, 1.0);
                    
                    cellModel.cellGoodsImage = [orderModel.listGoods[0] img];
                    cellModel.cellGoodsImageFrame = CGRectMake(10, CGRectGetMaxY(cellModel.lineViewFrame) + 14, 84, 84);
                    
                    cellModel.cellGoodsName = [NSString stringWithFormat:@"%@%@%@%@%@", [orderModel.listGoods[0] goodsName], [orderModel.listGoods[0] goodsName], [orderModel.listGoods[0] goodsName], [orderModel.listGoods[0] goodsName], [orderModel.listGoods[0] goodsName]];
                    cellModel.cellGoodsNameFrame = CGRectMake(CGRectGetMaxX(cellModel.cellGoodsImageFrame) + 12, CGRectGetMinY(cellModel.cellGoodsImageFrame), SCREEN_WIDTH - 20 - 84 - 12, 30);
                    
                    cellModel.cellGoodsSKU = [orderModel.listGoods[0] skuDesc];
                    cellModel.cellGoodsSKUFrame = CGRectMake(CGRectGetMinX(cellModel.cellGoodsNameFrame), CGRectGetMaxY(cellModel.cellGoodsNameFrame) + 14, CGRectGetWidth(cellModel.cellGoodsNameFrame), 15);
                    
                    cellModel.cellGoodsAmmount = [NSString stringWithFormat:@"¥%@", [orderModel.listGoods[0] amount]];
                    cellModel.cellGoodsAmmountFrame = CGRectMake(CGRectGetMinX(cellModel.cellGoodsNameFrame), CGRectGetMaxY(cellModel.cellGoodsSKUFrame) + 14, 80, 15);
                    
                    cellModel.cellGoodsNumber = [NSString stringWithFormat:@"x %zd", [orderModel.listGoods[0] number]];
                    cellModel.cellGoodsNumberFrame = CGRectMake(SCREEN_WIDTH - 10 - 50, CGRectGetMinY(cellModel.cellGoodsAmmountFrame), 50, 15);
                    
                    cellModel.cellHeight = CGRectGetMaxY(cellModel.cellGoodsImageFrame) + 14;
                    
                    [targetArray addObject:@[cellModel]];
                }
                
                if (targetArray.count == 0)
                {
                    WTUserHomeCellModel *cellModel = [[WTUserHomeCellModel alloc] init];
                    cellModel.className = @"WTInfoNormalCell";
                    cellModel.cellHeight = 0.0;
                    [targetArray addObject:@[cellModel]];
                }
                
                [cellModelArray addObjectsFromArray:targetArray];
                
            }
            break;
            
        default:
            break;
    }
    
    return cellModelArray;
}

+ (NSArray *)obtainAdviserHomeCellModelsWithUserInfoModel:(WTUserInfoModel *)infoModel isMySelf:(BOOL) isMySelf
{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    WTUserHomeCellModel *cellModel1 = [[WTUserHomeCellModel alloc] init];
    cellModel1.className = @"WTHeadIconCell";
    
    cellModel1.cellIcon = infoModel.img;
    cellModel1.iconFrame = CGRectMake(10, 18, 78, 78);
    
    cellModel1.cellName = infoModel.nickname;
    CGSize nameSize = [NSString sizeWithText:infoModel.nickname font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(SCREEN_WIDTH - 114, MAXFLOAT)];
    cellModel1.nameFrame = CGRectMake(CGRectGetMaxX(cellModel1.iconFrame) + 16, 18 + (78 - nameSize.height) * 0.5, nameSize.width, nameSize.height);
    
    cellModel1.cellSex = infoModel.sex;
    cellModel1.sexFrame = CGRectMake(CGRectGetMaxX(cellModel1.nameFrame) + 6, CGRectGetMinY(cellModel1.nameFrame), 20, 20);
    
    for (int i = 0; i < 5; i ++)
    {
        CGRect startRect = CGRectMake(i * (18 + 4) + CGRectGetMaxX(cellModel1.sexFrame) + 12, CGRectGetMinY(cellModel1.nameFrame), 18, 18);
        NSValue *rectValue = [NSValue valueWithCGRect:startRect];
        [cellModel1.startsFrameArray addObject:rectValue];
    }
    
    cellModel1.cellPlaceholer = infoModel.shopName;
    CGSize placeholderSize = [NSString sizeWithText:cellModel1.cellPlaceholer font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH - 114, 44)];
    cellModel1.placeholderFrame = CGRectMake(CGRectGetMinX(cellModel1.nameFrame), CGRectGetMaxY(cellModel1.nameFrame) + 14, placeholderSize.width, placeholderSize.height);
    
    cellModel1.cellHeight = 114.0;
    
    WTUserHomeCellModel *cellModel2 = [[WTUserHomeCellModel alloc] init];
    cellModel2.className = @"WTInfoNormalCell";
    cellModel2.cellTitle = @"地区";
    cellModel2.titleFrame = CGRectMake(10, 13, 50, 20);
    cellModel2.cellContent = [NSString isBlankString:infoModel.cityName] ? @"未完善" : infoModel.cityName;
    cellModel2.contentFrame = CGRectMake(104, 13, SCREEN_WIDTH - 108 - 10, 20);
    cellModel2.cellHeight = 46.0;
    
    WTUserHomeCellModel *cellModel3 = [[WTUserHomeCellModel alloc] init];
    cellModel3.className = @"WTInfoNormalCell";
    cellModel3.cellTitle = @"个性签名";
    cellModel3.cellContent = [NSString isBlankString:infoModel.sign] ? @"未完善" : infoModel.sign;
    CGSize signSize = [NSString sizeWithText:cellModel3.cellContent font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 114, MAXFLOAT)];
    cellModel3.contentFrame = CGRectMake(104, 16, signSize.width, signSize.height);
    cellModel3.cellHeight = CGRectGetMaxY(cellModel3.contentFrame) + 16;
    cellModel3.titleFrame = CGRectMake(10, (cellModel3.cellHeight - 20) * 0.5, 60, 20);
    
    
    WTUserHomeCellModel *cellModel4 = [[WTUserHomeCellModel alloc] init];
    cellModel4.className = @"WTInfoNormalCell";
    cellModel4.cellTitle = @"设置备注名和电话";
    cellModel4.titleFrame = CGRectMake(10, 13, 150, 20);
    cellModel4.cellHeight = 46.0;
    
    
    WTUserHomeCellModel *cellModel15 = [[WTUserHomeCellModel alloc] init];
    cellModel15.className = @"WTInfoNormalCell";
    cellModel15.cellTitle = @"电话号码";
    cellModel15.titleFrame = CGRectMake(10, 13, 80, 20);
    cellModel15.cellContent = infoModel.remtel;
    cellModel15.contentFrame = CGRectMake(104, 13, SCREEN_WIDTH - 108 - 10, 20);
    cellModel15.cellHeight = 46.0;
    
    if (isMySelf)
    {
        [modelArray addObjectsFromArray:@[@[cellModel1], @[cellModel2, cellModel3]]];
    }
    else
    {
        if ([NSString isBlankString:infoModel.remtel])
        {
            [modelArray addObjectsFromArray:@[@[cellModel1], @[cellModel2, cellModel3], @[cellModel4]]];
        }
        else
        {
            [modelArray addObjectsFromArray:@[@[cellModel1], @[cellModel2, cellModel3], @[cellModel4, cellModel15]]];
        }
    }
    
    return modelArray;
}

@end
