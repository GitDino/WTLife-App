//
//  WTUserHomeCellModel.h
//  wutong
//
//  Created by 魏欣宇 on 2018/8/5.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WTUserInfoModel, WTUserPictureModel, WTUserOrderModel;

@interface WTUserHomeCellModel : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) CGFloat cellHeight;


@property (nonatomic, copy) NSString *cellIcon;
@property (nonatomic, assign) CGRect iconFrame;

@property (nonatomic, copy) NSString *cellName;
@property (nonatomic, assign) CGRect nameFrame;

@property (nonatomic, assign) NSInteger cellSex;
@property (nonatomic, assign) CGRect sexFrame;

@property (nonatomic, strong) NSMutableArray *startsFrameArray;

@property (nonatomic, copy) NSString *cellPlaceholer;
@property (nonatomic, assign) CGRect placeholderFrame;

@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, assign) CGRect titleFrame;

@property (nonatomic, copy) NSString *cellContent;
@property (nonatomic, assign) CGRect contentFrame;

#pragma mark - 用户画像信息
@property (nonatomic, copy) NSString *cellRegisterTime;
@property (nonatomic, assign) CGRect cellRegisterTimeFrame;

@property (nonatomic, copy) NSString *cellLatestPayTime;
@property (nonatomic, assign) CGRect cellLatestPayTimeFrame;

@property (nonatomic, copy) NSString *cellTotalPayAmmount;
@property (nonatomic, assign) CGRect cellTotalPayAmmountFrame;

@property (nonatomic, copy) NSString *cellDayMaxAmmount;
@property (nonatomic, assign) CGRect cellDayMaxAmmountFrame;

@property (nonatomic, copy) NSString *cellRepeatBuyNumber;
@property (nonatomic, assign) CGRect cellRepeatBuyNumberFrame;

@property (nonatomic, copy) NSString *cellPerMaxAmmount;
@property (nonatomic, assign) CGRect cellPerMaxAmmountFrame;

@property (nonatomic, copy) NSString *cellPerOrderAmmount;
@property (nonatomic, assign) CGRect cellPerOrderAmmountFrame;

#pragma mark - 用户画像标签
@property (nonatomic, assign) BOOL isSystem;
@property (nonatomic, copy) NSString *cellSystemTitle;
@property (nonatomic, assign) CGRect cellSystemTitleFrame;

@property (nonatomic, copy) NSString *cellCustomTitle;
@property (nonatomic, assign) CGRect cellCustomTitleFrame;

@property (nonatomic, strong) NSArray *systemTagArray;
@property (nonatomic, strong) NSMutableArray *systemTagsFrameArray;
@property (nonatomic, assign) CGRect systemTagViewFrame;

@property (nonatomic, assign) CGRect addCustomTagBtnFrame;
@property (nonatomic, strong) NSArray *customTagArray;
@property (nonatomic, strong) NSMutableArray *customTagsFrameArray;
@property (nonatomic, assign) CGRect customTagViewFrame;

#pragma mark - 用户历史订单
@property (nonatomic, copy) NSString *cellOrderTime;
@property (nonatomic, assign) CGRect cellOrderTimeFrmae;

@property (nonatomic, copy) NSString *cellOrderInfo;
@property (nonatomic, assign) CGRect cellOrderInfoFrame;

@property (nonatomic, assign) CGRect lineViewFrame;

@property (nonatomic, copy) NSString *cellGoodsImage;
@property (nonatomic, assign) CGRect cellGoodsImageFrame;

@property (nonatomic, copy) NSString *cellGoodsName;
@property (nonatomic, assign) CGRect cellGoodsNameFrame;

@property (nonatomic, copy) NSString *cellGoodsSKU;
@property (nonatomic, assign) CGRect cellGoodsSKUFrame;

@property (nonatomic, copy) NSString *cellGoodsAmmount;
@property (nonatomic, assign) CGRect cellGoodsAmmountFrame;

@property (nonatomic, copy) NSString *cellGoodsNumber;
@property (nonatomic, assign) CGRect cellGoodsNumberFrame;

/**
 用户主页相关数据模型

 @param infoModel 用户信息
 @param pictureModel 用户画像
 @param orderModelArray 历史订单数组
 @param functionTag 标记
 */
+ (NSArray *)obtainUserHomeCellModelsWithUserInfoModel:(WTUserInfoModel *)infoModel userPictureModel:(WTUserPictureModel *)pictureModel userOrderModelArray:(NSArray *)orderModelArray functionTag:(NSInteger)functionTag;

/**
 顾问主页相关数据模型

 @param infoModel 用户信息
 @param isMySelf 是否是自己
 */
+ (NSArray *)obtainAdviserHomeCellModelsWithUserInfoModel:(WTUserInfoModel *)infoModel isMySelf:(BOOL) isMySelf;

@end
