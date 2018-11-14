//
//  WTFriendsListVC.m
//  wutong
//
//  Created by 魏欣宇 on 2018/9/18.
//  Copyright © 2018年 wutonglife. All rights reserved.
//

#import "WTFriendsListVC.h"
#import "WTGroupedContacts.h"

@interface WTFriendsListVC ()

@property (nonatomic, strong) WTGroupedContacts *contacts;

@end

@implementation WTFriendsListVC

#pragma mark - Life Cycle
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"通讯录";
    [self configNav];
    
    _contacts = [[WTGroupedContacts alloc] init];
}

- (void)configNav
{
    self.navigationController.navigationBar.tintColor = [UIColor wtBlackColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftBarButtonItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
